-- InfluxDB database for collecting data from
-- Shelly EM3 3-phase electricity meter

-- Create database and set default retention policy to 1 year.
CREATE DATABASE "emeters" WITH DURATION 52w REPLICATION 1

-- Create 2-year retention policy for downsampled historic data.
CREATE RETENTION POLICY "hourly" ON "emeters" DURATION 104w REPLICATION 1

-- Set up users for Grafana and Telegraf
CREATE USER grafana WITH PASSWORD 'password1'
CREATE USER telegraf WITH PASSWORD 'password2'

-- Grant read permissions to grafana and all permissions to Telegraf
GRANT READ ON emeters TO grafana
GRANT ALL ON emeters TO telegraf

USE emeters

-- Aggregate hourly minimum voltage
CREATE CONTINUOUS QUERY "min_voltage_60m" ON "emeters" BEGIN
    SELECT
        min("L1") as "L1",
        min("L2") as "L2",
        min("L3") as "L3"
    INTO "hourly"."min_voltage"
    FROM "voltage"
    GROUP BY time(60m)
END

-- Aggregate hourly maximum power
CREATE CONTINUOUS QUERY "max_power_60m" ON "emeters" BEGIN
    SELECT
        max("L1") as "L1",
        max("L2") as "L2",
        max("L3") as "L3"
    INTO "hourly"."max_power"
    FROM "power"
    GROUP BY time(60m)
END

-- Aggregate hourly total consumption
CREATE CONTINUOUS QUERY "total_60m" ON "emeters" BEGIN
    SELECT
        DIFFERENCE(first("L1")) AS "L1",
        DIFFERENCE(first("L2")) AS "L2",
        DIFFERENCE(first("L3")) AS "L3",
        DIFFERENCE(first("L1")) + DIFFERENCE(first("L2")) + DIFFERENCE(first("L3")) AS "Total"
    INTO "hourly"."total"
    FROM "total"
    GROUP BY time(1h)
END

