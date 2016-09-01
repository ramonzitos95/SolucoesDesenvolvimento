
SELECT te2usucod, 
	te2empcod, 
	te2procod, 
	te2cencod, 
	te2mes1, 
	te2mov1, 
	te2mes2, 
	te2mov2, 
	te2mes3, 
	te2mov3, 
	te2mes4, 
	te2mov4, 
	te2saldo, 
	te2produca, 
	te2reserva, 
	te2pedidoc, 
	te2medmov, 
	te2disp, 
	te2dispCom, 
	CASE WHEN te2medmov > 0 THEN Round(te2dispCom / te2medmov,2) 
		ELSE 0 
	END as te2MesCom, 
	CASE WHEN te2medmov > 0 THEN Round((te2dispCom / te2medmov) * 4,2) 
		ELSE 0 END as te2SemCom, 
	CASE WHEN Te2DispCom - Te2ProMin < 0 THEN (Te2DispCom - Te2ProMin) * -1 
		ELSE 0 END as te2SugComp  
FROM 
	(SELECT 
		*, 
		(te2mov1 + te2mov2 + te2mov3 + te2mov4) / 4 as te2medmov, 
		(te2saldo - te2reserva) as te2disp, 
		(te2saldo - te2reserva + te2pedidoc + te2produca) as te2dispCom 
	FROM (SELECT 
		99::INTEGER as te2usucod, 
		fi099.parcod as te2empcod,
		es001.procod as te2procod,
		0::INTEGER as te2cencod,
		es001.proponped as te2propon, 
		es001.promin as te2promin, 
		'2016-08-01'::DATE as te2mes1, 
		(SELECT 
			COALESCE(SUM(movqtd), 0) 
		FROM 
			es007 
		WHERE 
			movtrfmer = 0 
			AND movempcod = fi099.parcod 
			AND movpro = es001.procod 
			AND movdatmov >= '2016-08-01' 
			AND MovDatMov <= '2016-08-31' 
			AND MovTipMov = 'S' 
			and movodetip <> 'A') AS te2mov1,
			'2016-07-01'::DATE as te2mes2, 
			(SELECT 
				COALESCE(SUM(movqtd), 0) 
			FROM 
				es007 
			WHERE 
				movtrfmer = 0 
				AND movempcod = fi099.parcod 
				AND movpro = es001.procod 
				AND movdatmov >= '2016-07-01' 
				AND MovDatMov <= '2016-07-31' 
				AND MovTipMov = 'S' 
				and movodetip <> 'A') 
				AS te2mov2,'2016-06-01'::DATE as te2mes3, 
				(SELECT 
					COALESCE(SUM(movqtd), 0) 
				FROM 
					es007 
				WHERE 
					movtrfmer = 0 
					AND movempcod = fi099.parcod 
					AND movpro = es001.procod 
					AND movdatmov >= '2016-06-01' 
					AND MovDatMov <= '2016-06-30' 
					AND MovTipMov = 'S' 
					and movodetip <> 'A') AS te2mov3,
					'2016-05-01'::DATE as te2mes4, 
					(SELECT 
						COALESCE(SUM(movqtd), 0) 
					FROM 
						es007 
					WHERE 
						movtrfmer = 0 
						AND movempcod = fi099.parcod 
						AND movpro = es001.procod 
						AND movdatmov >= '2016-05-01' 
						AND MovDatMov <= '2016-05-31' 
						AND MovTipMov = 'S' 
						and movodetip <> 'A') AS te2mov4,
						(SELECT COALESCE(SUM(possal), 0) 
						FROM 
							es006 
						WHERE 
							posempcod = fi099.parcod 
							AND pospro = es001.procod) AS te2saldo, 
							(SELECT COALESCE(SUM(resqtd), 0) 
							FROM 
								pr008 
							WHERE 
								resempcod = fi099.parcod 
								AND resprocod = es001.procod) AS te2reserva, 
								(SELECT COALESCE(SUM(opsqtd), 0) 
								FROM 
									pr006 
								WHERE 
									opsempcod = fi099.parcod 
									AND opsprocod = es001.procod 
									AND opssit = 'A') AS te2produca, 
									(SELECT COALESCE(SUM(pdcqtdsal), 0) 
									FROM 
										co0061 
									WHERE 
										pdcempcod = fi099.parcod 
										AND co0061.procod = es001.procod 
										AND pdcqtdsal > 0) as te2pedidoc 
									FROM 
										es001 
									CROSS JOIN 
										fi099 
									WHERE 
										es001.prosit <> 0
										AND es001.procod = '0020612' 
									ORDER BY 1, 2) as nivel1 WHERE te2saldo + te2pedidoc <= te2propon) as nivel2
 2000000.00
select prosit, proponped from es001 where procod = '0020612'
update es001 set prosit = 1 where procod = '0020612'