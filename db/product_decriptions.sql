USE group6_music;

START TRANSACTION;

UPDATE products
SET description = 'YoungBoy Never Broke Again blends melodic rap with personal writing on 38 Baby 2, exploring heartbreak, distrust, and the pressures of his surroundings. His delivery shifts between wounded singing and forceful verses, giving the project an emotional intensity across its quieter moments and harder tracks.'
WHERE artist = 'YoungBoy Never Broke Again'
  AND name = '38 Baby 2';

UPDATE products
SET description = 'Tha Carter IV pairs Lil Wayne''s punchline-heavy verses with booming production and a softer, melodic side. Tracks including 6 Foot 7 Foot, the Drake-assisted She Will, and the acoustic How to Love give the album a mix of swagger, atmosphere, and vulnerability.'
WHERE artist = 'Lil Wayne'
  AND name = 'Tha Carter IV';

COMMIT;

-- Check the descriptions that were saved.
SELECT product_id, artist, name, description
FROM products
WHERE (artist = 'YoungBoy Never Broke Again' AND name = '38 Baby 2')
   OR (artist = 'Lil Wayne' AND name = 'Tha Carter IV');