ALTER TABLE IF EXISTS match_players DROP CONSTRAINT IF EXISTS fk_match_players_match;
ALTER TABLE IF EXISTS match_players DROP CONSTRAINT IF EXISTS fk_match_players_user;
ALTER TABLE IF EXISTS user_achievements DROP CONSTRAINT IF EXISTS fk_user_achievements_achievement;
ALTER TABLE IF EXISTS user_achievements DROP CONSTRAINT IF EXISTS fk_user_achievements_user;
ALTER TABLE IF EXISTS user_stats DROP CONSTRAINT IF EXISTS fk_user_stats_user;

DROP TABLE IF EXISTS user_achievements CASCADE;
DROP TABLE IF EXISTS match_players CASCADE;
DROP TABLE IF EXISTS user_stats CASCADE;
DROP TABLE IF EXISTS achievements CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS users CASCADE;

DROP SEQUENCE IF EXISTS user_seq;
DROP SEQUENCE IF EXISTS match_seq;
DROP SEQUENCE IF EXISTS achievement_seq;
DROP SEQUENCE IF EXISTS match_players_seq;
DROP SEQUENCE IF EXISTS user_achievements_seq;

CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE match_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE achievement_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE match_players_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_achievements_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE users (
    id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('user_seq'),
    nickname VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(500),
    birth_date DATE,
    gender VARCHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
    country VARCHAR(100),
    city VARCHAR(100),
    phone VARCHAR(20),
    bio TEXT,
    rating INT NOT NULL DEFAULT 1000,
    level INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE matches (
    id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('match_seq'),
    map_or_mode VARCHAR(50) NOT NULL,
    played_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

CREATE TABLE achievements (
    id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('achievement_seq'),
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url VARCHAR(500)
);

CREATE TABLE user_stats (
    user_id BIGINT NOT NULL PRIMARY KEY,
    matches_played INT DEFAULT 0,
    wins INT DEFAULT 0,
    losses INT DEFAULT 0,
    draws INT DEFAULT 0,
    total_kills INT DEFAULT 0,
    total_deaths INT DEFAULT 0
);

CREATE TABLE match_players (
    id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('match_players_seq'),
    match_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    match_result VARCHAR(10) NOT NULL CHECK (match_result IN ('WIN', 'LOSS', 'DRAW')),
    kills INT NOT NULL DEFAULT 0,
    deaths INT NOT NULL DEFAULT 0,
    assists INT NOT NULL DEFAULT 0,
    UNIQUE (match_id, user_id)
);

CREATE TABLE user_achievements (
    id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('user_achievements_seq'),
    user_id BIGINT NOT NULL,
    achievement_id BIGINT NOT NULL,
    unlocked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, achievement_id)
);

ALTER TABLE user_stats
    ADD CONSTRAINT fk_user_stats_user
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE match_players
    ADD CONSTRAINT fk_match_players_match
    FOREIGN KEY (match_id) REFERENCES matches (id) ON DELETE CASCADE;

ALTER TABLE match_players
    ADD CONSTRAINT fk_match_players_user
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE user_achievements
    ADD CONSTRAINT fk_user_achievements_user
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

ALTER TABLE user_achievements
    ADD CONSTRAINT fk_user_achievements_achievement
    FOREIGN KEY (achievement_id) REFERENCES achievements (id) ON DELETE CASCADE;

CREATE INDEX idx_match_players_user ON match_players (user_id);
CREATE INDEX idx_match_players_match ON match_players (match_id);
CREATE INDEX idx_user_achievements_user ON user_achievements (user_id);
CREATE INDEX idx_user_achievements_achievement ON user_achievements (achievement_id);
CREATE INDEX idx_matches_played_at ON matches (played_at);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_nickname ON users (nickname);