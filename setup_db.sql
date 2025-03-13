CREATE TYPE input_type AS ENUM (
    'multi_select_range', 'multi_select_radio', 'textarea', 
    'multi_select_checkbox', 'datetime', 'number'
);

CREATE TYPE section AS ENUM ('daily_check_in', 'onboarding');

CREATE TYPE category AS ENUM ('Menstrual', 'Behavioral');

CREATE TYPE subcategory AS ENUM ('Cycle', 'Sexual', 'Physical', 'Emotional', 'Social');

CREATE TYPE notification_preferences AS ENUM ('email', 'sms', 'push', 'none');

CREATE TYPE notification_frequency AS ENUM ('daily', 'weekly', 'monthly');

CREATE TYPE sex AS ENUM ('male', 'female', 'non-binary', 'Prefer not to say');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    email VARCHAR NOT NULL,
    notification_preferences notification_preferences NOT NULL DEFAULT 'none',
    notification_frequency notification_frequency
);

CREATE TABLE root_questions (
    question_key VARCHAR PRIMARY KEY,
    question_text VARCHAR,
    type_name input_type,
    required BOOLEAN,
    section section NOT NULL,
    category category,
    subcategory subcategory,
    question_labels TEXT[],
    question_values_int INTEGER[],
    question_values_text TEXT[],
    question_range INT4RANGE,
    dependent_question_keys TEXT[]
);

CREATE TABLE conditional_questions (
    question_key VARCHAR NOT NULL,
    trigger_question_key VARCHAR NOT NULL,
    trigger_value VARCHAR NOT NULL,
    PRIMARY KEY (question_key, trigger_question_key),
    FOREIGN KEY (question_key) REFERENCES root_questions (question_key),
    FOREIGN KEY (trigger_question_key) REFERENCES root_questions (question_key)
);

CREATE TABLE question_variations (
    variation_key VARCHAR PRIMARY KEY,
    question_key VARCHAR NOT NULL,
    question_text VARCHAR NOT NULL,
    type_name input_type,
    question_labels TEXT[],
    question_values_int INTEGER[],
    question_values_text TEXT[],
    question_range INT4RANGE,
    FOREIGN KEY (question_key) REFERENCES root_questions (question_key)
);

CREATE TABLE daily_checkin_responses (
    user_id INTEGER NOT NULL,
    question_key VARCHAR NOT NULL,
    variation_key VARCHAR,
    date DATE NOT NULL,
    response_value_int INTEGER,
    response_value_text VARCHAR,
    response_value_text_array TEXT[],
    PRIMARY KEY (user_id, question_key, date),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE onboarding_responses (
    user_id INTEGER NOT NULL,
    question_key VARCHAR NOT NULL,
    variation_key VARCHAR,
    response_value_date DATE,
    response_value_int INTEGER,
    response_value_text VARCHAR,
    response_value_text_array TEXT[],
    PRIMARY KEY (user_id, question_key),
    FOREIGN KEY (user_id) REFERENCES users (id)
);