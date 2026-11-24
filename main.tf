

resource "aws_iam_group" "employee_group" {
    for_each = local.departments
    name = each.key
    path = "/${each.key}/"
}

resource "aws_iam_user" "employee_user" {
    for_each = local.employees_map
    name = "${each.value.first_name}.${each.value.last_name}"   
    path = "/${each.value.first_name}_${each.value.last_name}/"  
}

resource "aws_iam_group_membership" "employee_group_membership" {
    for_each = local.employees_group_memberships
    name = "Membership to group: ${each.key} of Employees(indices): ${join(", ", each.value)}"

    group = each.key
    users = each.value
    depends_on = [ aws_iam_group.employee_group, aws_iam_user.employee_user ]
}