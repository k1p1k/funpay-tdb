-- 1. Пользователи
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    balance DOUBLE PRECISION NOT NULL DEFAULT 0,
    number BIGINT NULL,
    email VARCHAR(320) NOT NULL UNIQUE,
    password VARCHAR(32) NOT NULL
);

-- 2. Паспортные данные (связь 1 к 1 с users)
CREATE TABLE passport_data (
    user_id INTEGER PRIMARY KEY REFERENCES users(user_id) ON DELETE CASCADE,
    series SMALLINT NOT NULL,
    number SMALLINT NOT NULL,
    initials VARCHAR(128) NOT NULL,
    birthday TIMESTAMP NOT NULL,
    data_issue TIMESTAMP NOT NULL,
    issued VARCHAR(128) NOT NULL,
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    at_edit TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Сообщения
CREATE TABLE messages (
    msg_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recipent_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    text VARCHAR(512) NOT NULL,
    attachment VARCHAR(2048) NULL,
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Категории (с рекурсивной ссылкой на родительскую категорию)
CREATE TABLE categorys (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    under_category INTEGER NULL REFERENCES categorys(category_id) ON DELETE SET NULL
);

-- 5. Лоты (актуальная версия с проверкой цены)
CREATE TABLE lots (
    lot_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categorys(category_id) ON DELETE RESTRICT,
    price_unit NUMERIC(7, 2) NOT NULL CHECK (price_unit > 0),
    short_description VARCHAR(64) NOT NULL,
    description VARCHAR(512) NOT NULL,
    short_description_eng VARCHAR(64) NULL,
    description_eng VARCHAR(512) NULL,
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    at_edit TIMESTAMP NULL
);

-- 6. Сделки (актуальная версия с проверками и исправленной длиной status)
CREATE TABLE deals (
    deal_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    buyer_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    lot_id INTEGER NOT NULL REFERENCES lots(lot_id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL CHECK (status IN ('successful', 'cancel', 'successful_tp', 'cancel_tp')),
    quantity NUMERIC(5, 0) NOT NULL CHECK (quantity > 0),
    sum NUMERIC(8, 2) NOT NULL CHECK (sum > 0),
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. Финансовые транзакции
CREATE TABLE financial_transactions (
    transactions_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    deal_id INTEGER NULL REFERENCES deals(deal_id) ON DELETE SET NULL,
    sum NUMERIC(8, 2) NOT NULL,
    type_operation VARCHAR(12) NOT NULL CHECK (type_operation IN ('card', 'SPB')),
    type_transcation VARCHAR(12) NULL CHECK (type_transcation IN ('topup', 'withdrawal')),
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8. Отзывы
CREATE TABLE reviews (
    reviews_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    deal_id INTEGER NOT NULL REFERENCES deals(deal_id) ON DELETE CASCADE,
    text_user VARCHAR(512) NULL,
    text_seller VARCHAR(512) NULL,
    rating_progress SMALLINT NOT NULL CHECK (rating_progress >= 1 AND rating_progress <= 5),
    at_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    at_edit TIMESTAMP NULL
);
