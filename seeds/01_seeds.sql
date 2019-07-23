-- Users Table
INSERT INTO users (name, email, password)
VALUES ('Kendall Rowe', 'kendall.rowe312@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u'),
('Felix', '123kitty@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u'),
('Victoria Zefkic', 'victoria.zefkic@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u');

-- Properties Table
INSERT INTO properties (owner_id, title, description, thumbnail_photo_url, cover_photo_url, cost_per_night, parking_spaces, number_of_bathrooms, number_of_bedrooms, country, street, city, province, postal_code, active)
VALUES (1, 'Pod @ Lighthouse', 'A desk and sometimes a monitor?', 'www.adsfasdf.com', 'www.fdsafdsaf.com', 100, 0, 0, 1, 'Canada', '662 King St W', 'Toronto', 'Ontario', 'M5V 1M7', TRUE),
(2, 'Cat bed', 'Meow', 'www.adsfasdf.com', 'www.fdsafdsaf.com', 1000, 0, 1, 1, 'Canada', '51 Lower Simcoe', 'Toronto', 'Ontario', 'M5J 3A2', TRUE),
(2, 'Couch', 'Good nap spot... meow', 'www.adsfasdf.com', 'www.fdsafdsaf.com', 500, 1, 0, 1, 'Canada', '51 Lower Simcoe', 'Toronto', 'Ontario', 'M5J 3A2', TRUE);

-- Reservations Table
INSERT INTO reservations (property_id, guest_id, start_date, end_date)
VALUES (3, 1, Now(), Now()),
(1, 2, Now(), Now()),
(2, 3, Now(), Now());

-- Property Reviews Table
INSERT INTO property_reviews (guest_id, reservation_id, property_id, rating, message)
VALUES (1, 1, 3, 5, 'Thanks for the great stay!'),
(1, 2, 2, 4, 'It was good.'),
(2, 3, 3, 1, 'Wow that sucked... meow');