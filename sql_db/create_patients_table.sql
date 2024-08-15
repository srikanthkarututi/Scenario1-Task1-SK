-- Create the Patients table
CREATE TABLE Patients (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX),
    Condition NVARCHAR(MAX)
);

-- Insert data into the Patients table
INSERT INTO Patients (Name, Condition)
VALUES
    ('John Doe', 'Fever'),
    ('Jane Smith', 'Headache'),
    ('Michael Johnson', 'Stomachache'),
    ('Emily Brown', 'Cold'),
    ('William Davis', 'Flu'),
    ('Emma Wilson', 'Allergy'),
    ('James Taylor', 'Back pain'),
    ('Olivia Martinez', 'Sore throat'),
    ('Daniel Anderson', 'Sinusitis'),
    ('Sophia Thomas', 'Migraine'),
    ('Alexander White', 'Arthritis'),
    ('Isabella Harris', 'Asthma'),
    ('Matthew Clark', 'Diabetes'),
    ('Ava Allen', 'Hypertension'),
    ('Ethan King', 'Obesity'),
    ('Mia Lee', 'Anemia'),
    ('David Scott', 'Depression'),
    ('Ella Green', 'Insomnia'),
    ('Andrew Baker', 'Anxiety'),
    ('Grace Nelson', 'PTSD');
