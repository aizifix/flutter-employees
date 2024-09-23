<?php

function fetchEmployeeData($emp_id) {
    include "connection.php";

    $sql = "SELECT e.emp_id, e.emp_name, e.emp_basic_salary, d.department_text, s.stat_text 
            FROM tblemployees e
            INNER JOIN tblemployeedepartment d ON e.emp_department_id = d.department_id
            INNER JOIN tblemploymentstatus s ON e.emp_employee_status = s.stat_id
            WHERE e.emp_id = :emp_id";
    
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':emp_id', $emp_id, PDO::PARAM_INT);
    $stmt->execute();
    
    $employee = $stmt->fetch(PDO::FETCH_ASSOC);
    return $employee;
}

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch ($action) {
    case 'search':
        if (isset($_GET['emp_id'])) {
            $emp_id = intval($_GET['emp_id']);
            $employeeData = fetchEmployeeData($emp_id);
            
            if ($employeeData) {
                echo json_encode($employeeData);
            } else {
                echo json_encode(['error' => 'Employee not found']);
            }
        } else {
            echo json_encode(['error' => 'No employee ID provided']);
        }
        break;
    
    default:
        echo json_encode(['error' => 'Invalid action']);
        break;
}
?>
