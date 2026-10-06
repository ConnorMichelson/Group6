-- =====================================================================
-- Spin n' Ship — starter seed data
-- Run after schema.sql:  mysql -u root -p group6_music < db/seed.sql
--
-- Prices, quantities, and sales are sample values for demos.
-- release_year and description are left NULL to fill in later.
-- Images: put cover files at public/images/albums/<file>.jpg
-- =====================================================================

USE group6_music;

-- ---------------------------------------------------------------------
-- Products (all Vinyl to start)
-- A few are on sale and a few are sold out so the demo shows both.
-- ---------------------------------------------------------------------
INSERT INTO products (artist, name, genre, format, price, quantity, sale_price, sale_end, image_url) VALUES
('Faye Webster',      'Run and Tell',                            'Country', 'Vinyl', 26.99, 12, NULL,  NULL,                  'images/albums/run-and-tell.jpg'),
('Frank Ocean',       'Blonde',                                  'R&B',     'Vinyl', 44.99,  0, NULL,  NULL,                  'images/albums/blonde.jpg'),
-- TODO: confirm this album/artist with whoever added it
('Love Letter',       'You Look Good In Red',                    'Emo',     'Vinyl', 24.99,  0, NULL,  NULL,                  'images/albums/you-look-good-in-red.jpg'),
('BTS',               'Love Yourself: Answer',                   'Pop',     'Vinyl', 39.99, 15, NULL,  NULL,                  'images/albums/love-yourself-answer.jpg'),
('Metallica',         'Load',                                    'Rock',    'Vinyl', 36.99,  8, NULL,  NULL,                  'images/albums/load.jpg'),
('The Beatles',       'Love',                                    'Rock',    'Vinyl', 42.99,  6, NULL,  NULL,                  'images/albums/love.jpg'),
('Coldplay',          'X&Y',                                     'Rock',    'Vinyl', 34.99, 10, NULL,  NULL,                  'images/albums/x-and-y.jpg'),
('AC/DC',             'Black Ice',                               'Rock',    'Vinyl', 32.99,  9, NULL,  NULL,                  'images/albums/black-ice.jpg'),
('U2',                'Achtung Baby',                            'Rock',    'Vinyl', 34.99,  7, NULL,  NULL,                  'images/albums/achtung-baby.jpg'),
('P!NK',              'M!ssundaztood',                           'Rock',    'Vinyl', 29.99,  5, NULL,  NULL,                  'images/albums/missundaztood.jpg'),
('Rihanna',           'Unapologetic',                            'Pop',     'Vinyl', 31.99, 11, NULL,  NULL,                  'images/albums/unapologetic.jpg'),
('Hozier',            'Hozier',                                  'Blues',   'Vinyl', 32.99, 14, NULL,  NULL,                  'images/albums/hozier.jpg'),
('Pearl Jam',         'Ten',                                     'Rock',    'Vinyl', 27.99, 13, 21.99, '2026-12-31 23:59:59', 'images/albums/ten.jpg'),
('Gorillaz',          'Demon Days',                              'Rock',    'Vinyl', 32.99, 10, 24.99, '2026-12-31 23:59:59', 'images/albums/demon-days.jpg'),
('Post Malone',       'Stoney',                                  'Hip Hop', 'Vinyl', 36.99,  9, NULL,  NULL,                  'images/albums/stoney.jpg'),
('Miley Cyrus',       'Bangerz',                                 'Pop',     'Vinyl', 29.99,  4, NULL,  NULL,                  'images/albums/bangerz.jpg'),
('The Cranberries',   'No Need To Argue',                        'Rock',    'Vinyl', 28.99,  6, NULL,  NULL,                  'images/albums/no-need-to-argue.jpg'),
('Michael Buble',     'Call Me Irresponsible',                   'Pop',     'Vinyl', 27.99,  5, NULL,  NULL,                  'images/albums/call-me-irresponsible.jpg'),
('Ed Sheeran',        'Multiply',                                'Pop',     'Vinyl', 34.99, 12, NULL,  NULL,                  'images/albums/multiply.jpg'),
('Lady Gaga',         'The Fame',                                'Pop',     'Vinyl', 31.99,  8, NULL,  NULL,                  'images/albums/the-fame.jpg'),
('Avril Lavigne',     'Let Go',                                  'Rock',    'Vinyl', 29.99,  7, NULL,  NULL,                  'images/albums/let-go.jpg'),
('Cher',              'Believe',                                 'Pop',     'Vinyl', 27.99,  3, NULL,  NULL,                  'images/albums/believe.jpg'),
('One Direction',     'Four',                                    'Pop',     'Vinyl', 30.99,  9, NULL,  NULL,                  'images/albums/four.jpg'),
('Linkin Park',       'Minutes To Midnight',                     'Rock',    'Vinyl', 30.99, 11, NULL,  NULL,                  'images/albums/minutes-to-midnight.jpg'),
('Daughtry',          'Daughtry',                                'Rock',    'Vinyl', 26.99,  4, NULL,  NULL,                  'images/albums/daughtry.jpg'),
('Kings Of Leon',     'Only By The Night',                       'Rock',    'Vinyl', 28.99,  8, NULL,  NULL,                  'images/albums/only-by-the-night.jpg'),
('Bruno Mars',        'Doo-Wops & Hooligans',                    'Pop',     'Vinyl', 29.99, 10, NULL,  NULL,                  'images/albums/doo-wops-and-hooligans.jpg'),
('Blink-182',         'Enema Of The State',                      'Rock',    'Vinyl', 28.99,  7, NULL,  NULL,                  'images/albums/enema-of-the-state.jpg'),
('NCT Dream',         'Hot Sauce',                               'Pop',     'Vinyl', 35.99,  6, NULL,  NULL,                  'images/albums/hot-sauce.jpg'),
('Amy Winehouse',     'Back To Black',                           'R&B',     'Vinyl', 29.99, 15, 22.99, '2026-12-31 23:59:59', 'images/albums/back-to-black.jpg'),
('Bruno Mars',        'Unorthodox Jukebox',                      'Pop',     'Vinyl', 29.99,  9, NULL,  NULL,                  'images/albums/unorthodox-jukebox.jpg'),
('Olivia Rodrigo',    'Sour',                                    'Pop',     'Vinyl', 31.99, 18, NULL,  NULL,                  'images/albums/sour.jpg'),
('Justin Bieber',     'My World',                                'Pop',     'Vinyl', 24.99,  5, NULL,  NULL,                  'images/albums/my-world.jpg'),
('J. Cole',           '2014 Forest Hills Drive',                 'Hip Hop', 'Vinyl', 38.99, 10, NULL,  NULL,                  'images/albums/2014-forest-hills-drive.jpg'),
('Michael Jackson',   'History: Past, Present & Future Book I',  'Pop',     'Vinyl', 54.99,  3, NULL,  NULL,                  'images/albums/history.jpg'),
('Beyonce',           'Dangerously In Love',                     'Pop',     'Vinyl', 34.99,  7, NULL,  NULL,                  'images/albums/dangerously-in-love.jpg'),
('Usher',             'Confessions',                             'R&B',     'Vinyl', 36.99,  6, NULL,  NULL,                  'images/albums/confessions.jpg'),
('Lil Wayne',         'Tha Carter IV',                           'Hip Hop', 'Vinyl', 36.99,  5, NULL,  NULL,                  'images/albums/tha-carter-iv.jpg'),
('SZA',               'SOS',                                     'R&B',     'Vinyl', 42.99, 14, 34.99, '2026-12-31 23:59:59', 'images/albums/sos.jpg'),
('Dream Theater',     'Octavarium',                              'Rock',    'Vinyl', 39.99,  4, NULL,  NULL,                  'images/albums/octavarium.jpg'),
-- NOTE: "The Old Hurt of Being Left Behind" is a song; the album is "A Fortress Called Home"
('Seven Spires',      'The Old Hurt of Being Left Behind',       'Rock',    'Vinyl', 32.99,  3, NULL,  NULL,                  'images/albums/the-old-hurt-of-being-left-behind.jpg'),
('Wilderun',          'Sleep At the Edge of the Earth',          'Rock',    'Vinyl', 34.99,  0, NULL,  NULL,                  'images/albums/sleep-at-the-edge-of-the-earth.jpg'),
('White Ward',        'Love Exchange Failure',                   'Rock',    'Vinyl', 36.99,  2, NULL,  NULL,                  'images/albums/love-exchange-failure.jpg');

-- ---------------------------------------------------------------------
-- Discount codes (one valid percent, one flat with a minimum, one expired)
-- ---------------------------------------------------------------------
INSERT INTO discount_codes (code, description, discount_type, value, min_order, expires_at, active) VALUES
('WELCOME10', '10% off your order',                 'percent', 10.00,  0.00, NULL,                  TRUE),
('SPIN5',     '$5 off orders of $25 or more',       'flat',     5.00, 25.00, '2026-12-31 23:59:59', TRUE),
('SUMMER20',  '20% off (expired, for testing)',     'percent', 20.00,  0.00, '2026-08-31 23:59:59', TRUE);

-- ---------------------------------------------------------------------
-- Admin account
-- Passwords must be bcrypt hashes, so create admins through the app:
--   1. Register normally on the site (e.g. admin@spinnship.test)
--   2. Then run:
--      UPDATE customers SET is_admin = TRUE WHERE email = 'admin@spinnship.test';
-- ---------------------------------------------------------------------
