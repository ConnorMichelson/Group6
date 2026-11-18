-- Album descriptions for the existing products in db/seed.sql.
-- Run after schema.sql and seed.sql; this updates descriptions only.
-- Existing descriptions for these albums will be replaced.

USE group6_music;
SET NAMES utf8mb4;

START TRANSACTION;

-- Faye Webster - Run and Tell
UPDATE products
SET description = 'Faye Webster’s debut brings together gentle folk melodies, country influences, and an intimate vocal style. Its relaxed arrangements offer an early introduction to her thoughtful songwriting and understated charm.'
WHERE artist = 'Faye Webster'
  AND name = 'Run and Tell';

-- Frank Ocean - Blonde
UPDATE products
SET description = 'Frank Ocean explores love, memory, and growing older through atmospheric R&B and intimate storytelling. Songs including “Ivy,” “Pink + White,” and “Nights” move between quiet reflection and unexpected musical shifts.'
WHERE artist = 'Frank Ocean'
  AND name = 'Blonde';

-- Love Letter - You Look Good In Red
UPDATE products
SET description = 'Love Letter brings an emotionally direct approach to alternative and emo music on You Look Good In Red. Tracks including “With Everything In My Heart” and “I’ll Sing For You (Will You Ever Know)” introduce a collection built for listeners drawn to heartfelt expression.'
WHERE artist = 'Love Letter'
  AND name = 'You Look Good In Red';

-- BTS - Love Yourself: Answer
UPDATE products
SET description = 'BTS brings its Love Yourself series together with a mix of energetic pop, expressive rap, and reflective ballads. Songs including “IDOL,” “Euphoria,” and “Epiphany” trace a journey toward confidence and self-acceptance.'
WHERE artist = 'BTS'
  AND name = 'Love Yourself: Answer';

-- Metallica - Load
UPDATE products
SET description = 'Metallica explores blues-influenced grooves and a broader hard rock sound while keeping its heavy guitars and commanding vocals. “Until It Sleeps” and “Mama Said” reveal an album that balances muscular riffs with more personal, vulnerable moments.'
WHERE artist = 'Metallica'
  AND name = 'Load';

-- The Beatles - Love
UPDATE products
SET description = 'Familiar Beatles recordings take on new shapes through imaginative remixes and combinations created by George and Giles Martin. Designed for the Cirque du Soleil production, Love connects songs across the band’s catalog into a continuous musical experience.'
WHERE artist = 'The Beatles'
  AND name = 'Love';

-- Coldplay - X&Y
UPDATE products
SET description = 'Coldplay builds a spacious sound from shimmering guitars, synthesizers, and emotionally charged melodies. Featuring “Fix You” and “Speed of Sound,” X&Y pairs feelings of uncertainty with an enduring sense of hope.'
WHERE artist = 'Coldplay'
  AND name = 'X&Y';

-- AC/DC - Black Ice
UPDATE products
SET description = 'Black Ice delivers AC/DC’s signature combination of gritty vocals, driving rhythms, and unmistakable guitar riffs. Led by “Rock N Roll Train,” the album keeps its focus on loud, straightforward rock and roll.'
WHERE artist = 'AC/DC'
  AND name = 'Black Ice';

-- U2 - Achtung Baby
UPDATE products
SET description = 'U2 reshapes its sound with distorted guitars, electronic textures, and dance-influenced rhythms. “One,” “Mysterious Ways,” and “The Fly” anchor an album that moves between romantic tension, vulnerability, and bold experimentation.'
WHERE artist = 'U2'
  AND name = 'Achtung Baby';

-- P!NK - M!ssundaztood
UPDATE products
SET description = 'P!NK combines pop hooks with rock attitude and candid writing about identity, frustration, and family. From “Get the Party Started” to “Family Portrait,” M!ssundaztood moves between celebration and deeply personal reflection.'
WHERE artist = 'P!NK'
  AND name = 'M!ssundaztood';

-- YoungBoy Never Broke Again - 38 Baby 2
UPDATE products
SET description = 'YoungBoy Never Broke Again blends melodic rap with personal writing about heartbreak, distrust, and the pressures of his surroundings. His delivery shifts between wounded singing and forceful verses, giving the project an emotional intensity across its quieter moments and harder tracks.'
WHERE artist = 'YoungBoy Never Broke Again'
  AND name = '38 Baby 2';

-- Hozier - Hozier
UPDATE products
SET description = 'Hozier blends blues, soul, gospel influences, and earthy guitar work into songs about desire, devotion, and human connection. “Take Me to Church,” “From Eden,” and “Someone New” showcase his rich voice and vivid storytelling.'
WHERE artist = 'Hozier'
  AND name = 'Hozier';

-- Pearl Jam - Ten
UPDATE products
SET description = 'Pearl Jam’s debut pairs powerful guitar work with Eddie Vedder’s expressive vocals and emotionally intense writing. “Alive,” “Even Flow,” and “Jeremy” capture an album that confronts isolation and pain with an equally strong sense of determination.'
WHERE artist = 'Pearl Jam'
  AND name = 'Ten';

-- Gorillaz - Demon Days
UPDATE products
SET description = 'Gorillaz blends alternative pop, hip-hop, electronic music, and darker atmospheric sounds into a distinctive musical world. “Feel Good Inc.” and “DARE” bring infectious energy to an album threaded with anxiety, social commentary, and moments of hope.'
WHERE artist = 'Gorillaz'
  AND name = 'Demon Days';

-- Post Malone - Stoney
UPDATE products
SET description = 'Post Malone mixes melodic hip-hop with pop hooks and touches of country and rock. Featuring “White Iverson,” “Congratulations,” and “I Fall Apart,” Stoney moves between newfound success, heartbreak, and late-night reflection.'
WHERE artist = 'Post Malone'
  AND name = 'Stoney';

-- Miley Cyrus - Bangerz
UPDATE products
SET description = 'Miley Cyrus combines bold pop production with hip-hop influences and emotionally exposed ballads. “We Can’t Stop” and “Wrecking Ball” show the two sides of Bangerz: carefree rebellion and the difficult aftermath of a relationship.'
WHERE artist = 'Miley Cyrus'
  AND name = 'Bangerz';

-- The Cranberries - No Need To Argue
UPDATE products
SET description = 'The Cranberries brings together ringing guitars, reflective songwriting, and Dolores O’Riordan’s unmistakable voice. From the forceful “Zombie” to the tender “Ode to My Family,” the album explores conflict, memory, and emotional connection.'
WHERE artist = 'The Cranberries'
  AND name = 'No Need To Argue';

-- Michael Buble - Call Me Irresponsible
UPDATE products
SET description = 'Michael Bublé combines classic standards with contemporary songwriting, supported by warm vocals and polished orchestral arrangements. “Everything” and “Lost” sit alongside timeless favorites, giving the album both an easygoing swing and a romantic heart.'
WHERE artist = 'Michael Buble'
  AND name = 'Call Me Irresponsible';

-- Ed Sheeran - Multiply
UPDATE products
SET description = 'Ed Sheeran expands his acoustic songwriting with rhythmic pop, soul influences, and intimate ballads. “Sing,” “Photograph,” and “Thinking Out Loud” move between playful confidence, distant memories, and lasting love.'
WHERE artist = 'Ed Sheeran'
  AND name = 'Multiply';

-- Lady Gaga - The Fame
UPDATE products
SET description = 'Lady Gaga introduces a glittering world of dance-pop, electronic hooks, and fascination with celebrity culture. “Just Dance,” “Poker Face,” and “Paparazzi” give The Fame its combination of dance-floor energy and theatrical personality.'
WHERE artist = 'Lady Gaga'
  AND name = 'The Fame';

-- Avril Lavigne - Let Go
UPDATE products
SET description = 'Avril Lavigne pairs guitar-driven pop with teenage frustration, independence, and vulnerability. “Complicated,” “Sk8er Boi,” and “I’m with You” move from rebellious energy to quieter moments of uncertainty and longing.'
WHERE artist = 'Avril Lavigne'
  AND name = 'Let Go';

-- Cher - Believe
UPDATE products
SET description = 'Cher embraces electronic dance-pop with pulsing beats, confident vocals, and songs about moving forward after heartbreak. The title track and “Strong Enough” give the album an uplifting spirit built around resilience and independence.'
WHERE artist = 'Cher'
  AND name = 'Believe';

-- One Direction - Four
UPDATE products
SET description = 'One Direction combines its familiar vocal harmonies with a warmer sound influenced by pop-rock and classic guitar music. “Steal My Girl,” “Night Changes,” and “Stockholm Syndrome” balance youthful excitement with a more reflective approach to relationships.'
WHERE artist = 'One Direction'
  AND name = 'Four';

-- Linkin Park - Minutes To Midnight
UPDATE products
SET description = 'Linkin Park expands its sound with atmospheric arrangements, emotional ballads, and bursts of aggressive rock. “What I’ve Done,” “Bleed It Out,” and “Leave Out All the Rest” explore regret, frustration, and the desire to leave something meaningful behind.'
WHERE artist = 'Linkin Park'
  AND name = 'Minutes To Midnight';

-- Daughtry - Daughtry
UPDATE products
SET description = 'Daughtry’s debut combines heavy guitar hooks with Chris Daughtry’s gritty, expressive voice. “It’s Not Over” and “Home” lead a collection of rock songs about damaged relationships, perseverance, and finding where you belong.'
WHERE artist = 'Daughtry'
  AND name = 'Daughtry';

-- Kings Of Leon - Only By The Night
UPDATE products
SET description = 'Kings of Leon stretches its rock sound into spacious guitars, steady grooves, and soaring choruses. “Sex on Fire” and “Use Somebody” anchor an album filled with desire, loneliness, and restless late-night energy.'
WHERE artist = 'Kings Of Leon'
  AND name = 'Only By The Night';

-- Bruno Mars - Doo-Wops & Hooligans
UPDATE products
SET description = 'Bruno Mars blends pop, soul, reggae influences, and romantic songwriting into an easygoing debut. “Just the Way You Are,” “Grenade,” and “The Lazy Song” move between heartfelt devotion, disappointment, and carefree fun.'
WHERE artist = 'Bruno Mars'
  AND name = 'Doo-Wops & Hooligans';

-- Blink-182 - Enema Of The State
UPDATE products
SET description = 'Fast drums, bright guitar hooks, and irreverent humor give Enema of the State its unmistakable pop-punk energy. “What’s My Age Again?,” “All the Small Things,” and “Adam’s Song” balance youthful misbehavior with loneliness and the uncertainty of growing up.'
WHERE artist = 'Blink-182'
  AND name = 'Enema Of The State';

-- NCT Dream - Hot Sauce
UPDATE products
SET description = 'NCT DREAM combines energetic K-pop, rap, and smooth vocal harmonies across its first full-length album. The playful title track contrasts with more melodic songs such as “Dive Into You” and “Rainbow,” giving the record both bold personality and a softer side.'
WHERE artist = 'NCT Dream'
  AND name = 'Hot Sauce';

-- Amy Winehouse - Back To Black
UPDATE products
SET description = 'Amy Winehouse brings vintage soul and girl-group influences into sharply personal songs about heartbreak and troubled relationships. “Rehab,” “You Know I’m No Good,” and “Back to Black” pair memorable melodies with wit, vulnerability, and her unmistakable voice.'
WHERE artist = 'Amy Winehouse'
  AND name = 'Back To Black';

-- Bruno Mars - Unorthodox Jukebox
UPDATE products
SET description = 'Bruno Mars moves between funk, pop, reggae influences, and soulful ballads with an ear for vintage sounds. “Locked Out of Heaven,” “Treasure,” and “When I Was Your Man” showcase the album’s range from dance-floor confidence to stripped-back regret.'
WHERE artist = 'Bruno Mars'
  AND name = 'Unorthodox Jukebox';

-- Olivia Rodrigo - Sour
UPDATE products
SET description = 'Olivia Rodrigo turns heartbreak, insecurity, and teenage frustration into intimate ballads and explosive guitar-driven pop. “Drivers License,” “Deja Vu,” and “Good 4 U” capture the changing emotions of a breakup with direct, personal songwriting.'
WHERE artist = 'Olivia Rodrigo'
  AND name = 'Sour';

-- Justin Bieber - My World
UPDATE products
SET description = 'Justin Bieber’s debut EP combines youthful pop with smooth R&B influences and songs about first love. “One Time” and “One Less Lonely Girl” introduce the bright melodies and romantic charm that shaped his early sound.'
WHERE artist = 'Justin Bieber'
  AND name = 'My World';

-- J. Cole - 2014 Forest Hills Drive
UPDATE products
SET description = 'J. Cole reflects on his upbringing, ambition, and the meaning of success through personal storytelling and soulful hip-hop production. “No Role Modelz,” “Apparently,” and “Love Yourz” connect memories of his past with lessons about the life he wants to build.'
WHERE artist = 'J. Cole'
  AND name = '2014 Forest Hills Drive';

-- Michael Jackson - History: Past, Present & Future Book I
UPDATE products
SET description = 'This two-part collection brings together Michael Jackson’s established hits and a full album of new material from its original release. Familiar favorites share the spotlight with “Scream,” “Earth Song,” and “You Are Not Alone,” connecting his pop legacy with more personal and socially focused songs.'
WHERE artist = 'Michael Jackson'
  AND name = 'History: Past, Present & Future Book I';

-- Beyonce - Dangerously In Love
UPDATE products
SET description = 'Beyoncé’s solo debut blends confident R&B, hip-hop collaborations, and expressive romantic ballads. “Crazy in Love,” “Baby Boy,” and “Dangerously in Love 2” showcase both her commanding energy and the emotional range of her voice.'
WHERE artist = 'Beyonce'
  AND name = 'Dangerously In Love';

-- Usher - Confessions
UPDATE products
SET description = 'Usher pairs smooth R&B vocals with dance-floor hits and relationship stories shaped by temptation, regret, and difficult admissions. “Yeah!,” “Burn,” and “Confessions Part II” move between celebration and emotional fallout.'
WHERE artist = 'Usher'
  AND name = 'Confessions';

-- Lil Wayne - Tha Carter IV
UPDATE products
SET description = 'Tha Carter IV pairs Lil Wayne’s punchline-heavy verses with booming production and a softer, melodic side. Tracks including “6 Foot 7 Foot,” the Drake-assisted “She Will,” and the acoustic “How to Love” give the album a mix of swagger, atmosphere, and vulnerability.'
WHERE artist = 'Lil Wayne'
  AND name = 'Tha Carter IV';

-- SZA - SOS
UPDATE products
SET description = 'SZA explores heartbreak, jealousy, self-worth, and independence through R&B, pop, rap, and guitar-driven detours. “Kill Bill,” “Snooze,” and “Good Days” capture an album that moves freely between sharp humor, emotional uncertainty, and moments of clarity.'
WHERE artist = 'SZA'
  AND name = 'SOS';

-- Dream Theater - Octavarium
UPDATE products
SET description = 'Dream Theater balances intricate progressive metal with melodic rock, expressive keyboards, and quieter passages. “Panic Attack,” “The Answer Lies Within,” and the extended title track demonstrate the album’s range from immediate intensity to expansive musical storytelling.'
WHERE artist = 'Dream Theater'
  AND name = 'Octavarium';

-- Wilderun - Sleep At the Edge of the Earth
UPDATE products
SET description = 'Wilderun combines progressive metal, folk instrumentation, and orchestral arrangements into a sweeping, cinematic sound. Gentle acoustic passages give way to powerful vocals and heavy guitars, with the multipart “Ash Memory” forming a central musical journey.'
WHERE artist = 'Wilderun'
  AND name = 'Sleep At the Edge of the Earth';

-- White Ward - Love Exchange Failure
UPDATE products
SET description = 'White Ward blends atmospheric black metal with saxophone, piano, and shadowy jazz passages. Its shifts between harsh intensity and quieter reflection create an unsettling portrait of urban isolation and emotional disconnection.'
WHERE artist = 'White Ward'
  AND name = 'Love Exchange Failure';

COMMIT;

-- Review the saved product descriptions.
SELECT product_id, artist, name, description
FROM products
ORDER BY artist, name;
