INSERT INTO users (balance, number, email, password) VALUES
(1500.50, 79001112233, 'ivanov@example.com', 'hash_pass_12345'),
(5400.00, 79004445566, 'petrov_seller@example.com', 'hash_pass_67890'),
(0.00, NULL, 'sidorov_new@example.com', 'hash_pass_abcdef');

INSERT INTO passport_data (user_id, series, number, initials, birthday, data_issue, issued) VALUES
(1, 4510, 12345, 'Иванов Иван Иванович', '1995-05-15 00:00:00', '2015-06-01 00:00:00', 'ОУФМС России по г. Москве'),
(2, 4612, 31500, 'Петров Петр Петрович', '1990-10-20 00:00:00', '2010-11-12 00:00:00', 'ТП №1 ОУФМС России по Московской обл.');

INSERT INTO messages (sender_id, recipent_id, text, attachment) VALUES
(1, 2, 'Здравствуйте! Товар ещё в наличии?', NULL),
(2, 1, 'Добрый день! Да, всё актуально, вот скриншот.', 'https://example.com'),
(1, 2, 'Отлично, оформляю заказ.', NULL);

INSERT INTO categorys (name, under_category) VALUES
('Игры', NULL),           -- category_id = 1
('Программы', NULL),      -- category_id = 2
('Аккаунты', 1),          -- category_id = 3 (подкатегория Игр)
('Игровая валюта', 1);    -- category_id = 4 (подкатегория Игр)

INSERT INTO lots (seller_id, category_id, price_unit, short_description, description, short_description_eng, description_eng) VALUES
(2, 3, 1200.00, 'Аккаунт с редкими скинами', 'Полный доступ, смена почты и пароля. Гарантия качества.', 'Account with rare skins', 'Full access, email and password change.'),

INSERT INTO deals (seller_id, buyer_id, lot_id, status, quantity, sum) VALUES
(2, 1, 1, 'successful', 1, 1200.00),     -- deal_id = 1
(2, 1, 2, 'successful_tp', 10, 500.00),  -- deal_id = 2
(2, 1, 2, 'cancel', 5, 250.00);          -- deal_id = 3

INSERT INTO financial_transactions (user_id, deal_id, sum, type_operation, type_transcation) VALUES
(1, NULL, 3000.00, 'card', 'topup'),       -- Пополнение баланса покупателем
(1, 1, 1200.00, 'card', NULL),             -- Оплата первой сделки
(1, 2, 500.00, 'SPB', NULL),               -- Оплата второй сделки через СБП
(2, NULL, 1500.00, 'SPB', 'withdrawal');   -- Вывод средств продавцом

INSERT INTO reviews (deal_id, text_user, text_seller, rating_progress) VALUES
(1, 'Всё прошло быстро и честно, рекомендую продавца!', 'Спасибо за покупку, обращайтесь ещё!', 5),
(2, 'Валюта пришла с небольшой задержкой, но через поддержку всё решили.', 'Приносим извинения за ожидание.', 4);
