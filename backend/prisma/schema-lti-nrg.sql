-- Table: COMPANY
CREATE TABLE COMPANY (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: CONTACT_INFO
CREATE TABLE CONTACT_INFO (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255)
);

-- Table: EMPLOYEE
CREATE TABLE EMPLOYEE (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES COMPANY(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    contact_id INTEGER NOT NULL REFERENCES CONTACT_INFO(id) ON DELETE CASCADE,
    role VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);

-- Table: INTERVIEW_FLOW
CREATE TABLE INTERVIEW_FLOW (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL
);

-- Table: INTERVIEW_TYPE
CREATE TABLE INTERVIEW_TYPE (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Table: INTERVIEW_STEP
CREATE TABLE INTERVIEW_STEP (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER NOT NULL REFERENCES INTERVIEW_FLOW(id) ON DELETE CASCADE,
    interview_type_id INTEGER NOT NULL REFERENCES INTERVIEW_TYPE(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    order_index INTEGER NOT NULL
);

-- Table: POSITION
CREATE TABLE POSITION (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES COMPANY(id) ON DELETE CASCADE,
    interview_flow_id INTEGER REFERENCES INTERVIEW_FLOW(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL,
    is_visible BOOLEAN DEFAULT TRUE,
    location VARCHAR(255),
    salary_min NUMERIC(10, 2),
    salary_max NUMERIC(10, 2),
    employment_type VARCHAR(50)
);

-- Table: POSITION_DETAILS
CREATE TABLE POSITION_DETAILS (
    position_id INTEGER PRIMARY KEY REFERENCES POSITION(id) ON DELETE CASCADE,
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    benefits TEXT,
    company_description TEXT,
    application_deadline DATE,
    contact_info VARCHAR(255)
);

-- Table: CANDIDATE
CREATE TABLE CANDIDATE (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    contact_id INTEGER NOT NULL REFERENCES CONTACT_INFO(id) ON DELETE CASCADE
);

-- Table: APPLICATION
CREATE TABLE APPLICATION (
    id SERIAL PRIMARY KEY,
    position_id INTEGER NOT NULL REFERENCES POSITION(id) ON DELETE CASCADE,
    candidate_id INTEGER NOT NULL REFERENCES CANDIDATE(id) ON DELETE CASCADE,
    application_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    notes TEXT
);

-- Table: INTERVIEW
CREATE TABLE INTERVIEW (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL REFERENCES APPLICATION(id) ON DELETE CASCADE,
    interview_step_id INTEGER NOT NULL REFERENCES INTERVIEW_STEP(id) ON DELETE CASCADE,
    employee_id INTEGER REFERENCES EMPLOYEE(id) ON DELETE SET NULL,
    interview_date DATE NOT NULL,
    result VARCHAR(50),
    score INTEGER,
    notes TEXT
);

-- Indexes for Optimization
CREATE INDEX idx_employee_company ON EMPLOYEE(company_id);
CREATE INDEX idx_candidate_contact ON CANDIDATE(contact_id);
CREATE INDEX idx_employee_contact ON EMPLOYEE(contact_id);
CREATE INDEX idx_position_company ON POSITION(company_id);
CREATE INDEX idx_position_status ON POSITION(status);
CREATE INDEX idx_application_position ON APPLICATION(position_id);
CREATE INDEX idx_application_candidate ON APPLICATION(candidate_id);
CREATE INDEX idx_interview_application ON INTERVIEW(application_id);
CREATE INDEX idx_interview_step ON INTERVIEW(interview_step_id);


-- Additional Indexes
CREATE INDEX idx_company_name ON COMPANY(name);

CREATE INDEX idx_employee_contact ON EMPLOYEE(contact_id);

CREATE INDEX idx_contact_phone ON CONTACT_INFO(phone);

CREATE INDEX idx_position_location ON POSITION(location);

CREATE INDEX idx_candidate_name ON CANDIDATE(first_name, last_name);

CREATE INDEX idx_interview_employee ON INTERVIEW(employee_id);

CREATE INDEX idx_step_flow ON INTERVIEW_STEP(interview_flow_id);

-- Compound Indexes
CREATE INDEX idx_application_position_status ON APPLICATION(position_id, status);

CREATE INDEX idx_interview_application_employee ON INTERVIEW(application_id, employee_id);