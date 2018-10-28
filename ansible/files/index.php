<?php
error_reporting(E_ALL ^ E_NOTICE);

if (in_array($_SERVER['REQUEST_URI'], [ '/show-ips', '/blacklisted' ])) {
    require_once('/opt/config.php');

    $db = new PDO("pgsql:dbname={$db['name']};host={$db['host']}", "{$db['user']}", "{$db['pass']}");

    if ($_SERVER['REQUEST_URI'] == '/show-ips') {
        $query = $db->prepare("select * from data");
        $query->execute();

        print_r([ '<pre>', $query->fetchAll(PDO::FETCH_ASSOC) ]);
    }

    if ($_SERVER['REQUEST_URI'] == '/blacklisted') {
        $query = $db->prepare("insert into data (path, ip, date) values (?, ?, ?)");

        $query->bindParam(1, $_SERVER['REQUEST_URI']);
        $query->bindParam(2, $_SERVER['REMOTE_ADDR']);
        $query->bindParam(3, date("Y-m-d H:i:s"));

        $query->execute();

        mail("test@domain.com", "Ip blocked", "Ip address was blocked: {$_SERVER['REQUEST_URI']}");

        http_response_code(444);
    }
    die;
}

if (!is_numeric($_GET['n'])) die('only numeric');

function fib($n) { 
    $f = [ 0 ];

    if ($n < 1) return $f;

    $f[] = 1;

    for ($i = 2; $i <= $n; $i++) {
        $f[] = $f[$i-1] + $f[$i-2];
    }

    return $f;
}

echo join(', ', fib(($_GET['n'] | 0)));