CREATE TABLE passengers (
    p_id         INT PRIMARY KEY,
    is_survived  BOOLEAN NOT NULL,
    p_class      INT NOT NULL,
    name         TEXT,
    surname      TEXT,
    title        TEXT,
    sex          TEXT,
    age          NUMERIC(4, 1),
    sib_sp       INT,
    par_ch       INT,
    family_size  INT,
    ticket       TEXT,
    fare         NUMERIC(8, 2),
    cabin        TEXT,
    embarked     TEXT
);