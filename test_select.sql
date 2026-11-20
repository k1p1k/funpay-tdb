select number from users;

select sum(balance) from users;

select user_id from financial_transactions
where type_transcation = 'withdrawal' and at_created  >= CURRENT_DATE - INTERVAL '3 months';

with vars (user1, user2) as (
  values  (10, 14)
)
select m.text, m.attachment 
from messages m
cross join vars v
where (m.sender_id = v.user1 and m.recipent_id = v.user2) 
   or (m.sender_id = v.user2 and m.recipent_id = v.user1)
order by m.at_created ASC;


-- 1. список верифицированных пользователей
select user_id, email, balance
from users
where exists (
    select 1 
    from passport_data 
    where passport_data.user_id = users.user_id
);

-- 2. каталог лотов с названием категории и email продавца
select 
    lots.lot_id, 
    lots.short_description, 
    lots.price_unit,
    (select categorys.name from categorys where categorys.category_id = lots.category_id) as category_name,
    (select users.email from users where users.user_id = lots.seller_id) as seller_email
from lots
order by lots.at_created desc;

-- 3. список корневых категорий (без родительской категории)
select category_id, name
from categorys
where under_category is null;

-- 4. средний рейтинг и количество отзывов по каждому продавцу
select deals.seller_id, count(reviews.reviews_id) as reviews_count, round(avg(reviews.rating_progress), 2) as avg_rating
from deals, reviews
where deals.deal_id = reviews.deal_id
group by deals.seller_id
order by avg_rating desc;

-- 5. топ-5 самых дорогих успешных сделок
select deal_id, seller_id, buyer_id, lot_id, quantity, sum, at_created
from deals
where status in ('successful', 'successful_tp')
order by sum desc
limit 5;

-- 6. общая сумма пополнений и выводов по каждому типу операции
select type_operation, type_transcation, count(*) as tx_count, sum(sum) as total_amount
from financial_transactions
where type_transcation is not null
group by type_operation, type_transcation;

-- 7. лоты, которые ни разу не покупали
select lot_id, short_description, price_unit
from lots
where lot_id not in (
    select lot_id 
    from deals
);

-- 8. количество входящих сообщений для каждого пользователя
select recipent_id as user_id, count(msg_id) as incoming_messages
from messages
group by recipent_id
order by incoming_messages desc;

-- 9. сделки с оценкой ниже 3 и текстом отзыва
select deals.deal_id, deals.status, reviews.rating_progress, reviews.text_user, reviews.text_seller
from deals, reviews
where deals.deal_id = reviews.deal_id 
  and reviews.rating_progress < 3;

-- 10. пользователи с положительным балансом, но без привязанного номера телефона
select user_id, email, balance
from users
where balance > 0 and number is null
order by balance desc;
