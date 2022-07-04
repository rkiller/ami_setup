#!/usr/bin/env bash
if ! yum list installed | grep 'snowflake-odbc'; then
	ARCHITECTURE=$(uname -m)
	sudo cp snowflake.repo.$ARCHITECTURE /etc/yum.repos.d/snowflake.repo
	sudo yum -y install unixODBC.$ARCHITECTURE
	sudo yum -y install unixODBC-devel.$ARCHITECTURE
	sudo yum -y install snowflake-odbc
	sudo bash -c 'echo "[ODBC Data Sources]" > /etc/odbc.ini'
	sudo bash -c 'echo "SnowflakeDSIIDriver" >> /etc/odbc.ini'
	sudo bash -c 'echo "" >> /etc/odbc.ini'
	sudo bash -c 'echo "[SNOWFLAKE_ODBC]" >> /etc/odbc.ini'
	sudo bash -c 'echo "Driver      = /usr/lib64/snowflake/odbc/lib/libSnowflake.so" >> /etc/odbc.ini'
	sudo bash -c 'echo "Description = Athena Snowflake" >> /etc/odbc.ini'
	sudo bash -c 'echo "uid         = CLINEVADATAVIEWACCESS" >> /etc/odbc.ini'
	sudo bash -c 'echo "server      = mua14638.snowflakecomputing.com" >> /etc/odbc.ini'
	sudo bash -c 'echo "warehouse   = AH_WAREHOUSE" >> /etc/odbc.ini'
	sudo bash -c 'echo "database    = ATHENAHEALTH" >> /etc/odbc.ini'
	sudo bash -c 'echo "schema      = ATHENAONE" >> /etc/odbc.ini'
	# Log tracing -> Turning this on may cause UTF-8 Issues
	# 0 or LOG_OFF: no logging occurs
	# 1 or LOG_FATAL: only log fatal errors
	# 2 or LOG_ERROR: log all errors
	# 3 or LOG_WARNING: log all errors and warnings
	# 4 or LOG_INFO: log all errors, warnings, and informational messages
	# 5 or LOG_DEBUG: log method entry and exit points and parameter values for debugging
	# 6 or LOG_TRACE: log all method entry points
	# sudo bash -c 'echo "tracing     = 6" >> /etc/odbc.ini' # --> Will Turn on ALL LOGS
	sudo bash -c 'echo "tracing     = 0" >> /etc/odbc.ini'
else
	echo "Snowflake already installed"
fi