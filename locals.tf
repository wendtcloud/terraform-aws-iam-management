locals {
    employees = csvdecode(file("./inputs/users.csv"))

    employees_map = { for index, employee in local.employees : tostring(index) => employee }

    departments = toset([for entry in local.employees : lower(replace(entry["department"], " ", "_"))])

    employees_group_memberships = {
        for department in local.departments : department => [for index, entry in local.employees_map : "${entry["first_name"]}.${entry["last_name"]}" if lower(replace(entry["department"], " ", "_")) == department]
    }
}