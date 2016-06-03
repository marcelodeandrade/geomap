<?php 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

	include 'Database.php';

	function getRegiao($post)
	{
		switch ($post['regiao']) {
			case 'estado':
			$sql = "SELECT codigo, nome FROM estado ORDER BY nome";
			break;			
			case 'mesorregiao':
			$sql = "SELECT codigo, nome FROM mesorregiao WHERE codigo_estado = ".(int)$post['codigo']." ORDER BY nome";
			break;			
			case 'microrregiao':
			$sql = "SELECT codigo, nome FROM microrregiao WHERE codigo_mesorregiao = ".(int)$post['codigo']." ORDER BY nome";
			break;			
		}

		$pdo = Database::conexao();
		$stmt = $pdo->query($sql);
		echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
	}

	function getMunicipios($post)
	{
		$sql = "SELECT m.codigo FROM municipio m INNER JOIN microrregiao micro ON micro.codigo = m.codigo_microrregiao INNER JOIN mesorregiao meso ON meso.codigo = micro.codigo_mesorregiao INNER JOIN estado e ON e.codigo = meso.codigo_estado";

		switch ($post['regiao']) {
			case 'estado':
				$sql .= " WHERE e.codigo = " . (int)$post['codigo'] . ""; 
				break;			
			case 'mesorregiao':
				$sql .= " WHERE meso.codigo = " . (int)$post['codigo'] . ""; 
				break;			
			case 'microrregiao':
				$sql .= " WHERE micro.codigo = " . (int)$post['codigo'] . ""; 
				break;			
		}

		$pdo = Database::conexao();
		$stmt = $pdo->query($sql);
		echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
	}
	
	if(isset($_POST['mapa']) && $_POST['mapa'] == true){
		getMunicipios($_POST);
	} else {
		getRegiao($_POST);
	}
}