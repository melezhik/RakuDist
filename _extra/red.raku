package-install "postgresql postgresql-contrib";
service-enable "postgresql";
service-start "postgresql";
task-run "check postgresql", "postgresql-check";
