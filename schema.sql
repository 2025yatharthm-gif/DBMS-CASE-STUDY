CREATE TABLE card_holder (
    card_id INT PRIMARY KEY,
    card_number VARCHAR(20) UNIQUE NOT NULL,
    head_name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    family_size INT NOT NULL CHECK (family_size > 0)
);


CREATE TABLE family_member (
    member_id INT PRIMARY KEY,
    card_id INT NOT NULL,
    member_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0),
    relation VARCHAR(50),
    FOREIGN KEY (card_id) REFERENCES card_holder(card_id)
);


CREATE TABLE commodity (
    commodity_id INT PRIMARY KEY,
    commodity_name VARCHAR(50) UNIQUE NOT NULL,
    unit VARCHAR(20) NOT NULL,
    price_per_unit DECIMAL(10,2) CHECK (price_per_unit >= 0)
);


CREATE TABLE entitlement (
    entitlement_id INT PRIMARY KEY,
    commodity_id INT NOT NULL,
    min_family_size INT NOT NULL,
    max_family_size INT NOT NULL,
    quantity_allowed DECIMAL(10,2) NOT NULL CHECK (quantity_allowed >= 0),
    FOREIGN KEY (commodity_id) REFERENCES commodity(commodity_id),
    CHECK (min_family_size <= max_family_size)
);


CREATE TABLE stock (
    stock_id INT PRIMARY KEY,
    commodity_id INT UNIQUE NOT NULL,
    quantity_available DECIMAL(10,2) NOT NULL CHECK (quantity_available >= 0),
    FOREIGN KEY (commodity_id) REFERENCES commodity(commodity_id)
);


CREATE TABLE distribution (
    distribution_id INT PRIMARY KEY,
    card_id INT NOT NULL,
    commodity_id INT NOT NULL,
    quantity_issued DECIMAL(10,2) NOT NULL CHECK (quantity_issued > 0),
    issue_date DATE NOT NULL,
    FOREIGN KEY (card_id) REFERENCES card_holder(card_id),
    FOREIGN KEY (commodity_id) REFERENCES commodity(commodity_id)
);

CREATE OR REPLACE FUNCTION check_distribution()
RETURNS TRIGGER AS $$
DECLARE
    allowed_quantity DECIMAL(10,2);
    already_issued DECIMAL(10,2);
    available_stock DECIMAL(10,2);
BEGIN

    -- Find monthly entitlement for the card holder
    SELECT e.quantity_allowed
    INTO allowed_quantity
    FROM card_holder c
    JOIN entitlement e
        ON c.family_size BETWEEN e.min_family_size
                             AND e.max_family_size
    WHERE c.card_id = NEW.card_id
      AND e.commodity_id = NEW.commodity_id;

    -- Calculate quantity already issued in the same month
    SELECT COALESCE(SUM(quantity_issued), 0)
    INTO already_issued
    FROM distribution
    WHERE card_id = NEW.card_id
      AND commodity_id = NEW.commodity_id
      AND DATE_TRUNC('month', issue_date) =
          DATE_TRUNC('month', NEW.issue_date);

    -- Check monthly entitlement
     IF allowed_quantity IS NULL THEN
    RAISE EXCEPTION
    'No entitlement exists for this family size and commodity';
END IF;

IF already_issued + NEW.quantity_issued > allowed_quantity THEN
    RAISE EXCEPTION
    'Distribution exceeds monthly entitlement';
END IF;

    -- Check available stock
    SELECT quantity_available
    INTO available_stock
    FROM stock
    WHERE commodity_id = NEW.commodity_id;

    IF NEW.quantity_issued > available_stock THEN
        RAISE EXCEPTION
        'Distribution exceeds available stock';
    END IF;

    -- Reduce stock after successful distribution
    UPDATE stock
    SET quantity_available = quantity_available - NEW.quantity_issued
    WHERE commodity_id = NEW.commodity_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_over_distribution
BEFORE INSERT ON distribution
FOR EACH ROW
EXECUTE FUNCTION check_distribution();

-- ==========================================
-- INDEXES
-- ==========================================

-- Single-column index
CREATE INDEX idx_distribution_issue_date
ON distribution(issue_date);


-- Single-column index
CREATE INDEX idx_card_holder_family_size
ON card_holder(family_size);


-- Composite index
CREATE INDEX idx_distribution_card_date
ON distribution(card_id, issue_date);