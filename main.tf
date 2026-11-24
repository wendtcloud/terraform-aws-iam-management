

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

resource "aws_iam_policy" "s3_read_only" {
    name   = "s3-read-only"
    policy = data.aws_iam_policy_document.s3_read_only.json
}

resource "aws_iam_group_policy_attachment" "employee_group_policy_attachment" {
    for_each = aws_iam_group.employee_group
    
    group = each.value.name
    policy_arn = aws_iam_policy.s3_read_only.arn
}