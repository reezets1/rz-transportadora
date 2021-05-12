 -- Não altere o ['job'] = 'truck-driver' ou seu script irá parar de funcionar
config_drawMarkers = {
    {['x'] = 1215.82, ['y'] = -3242.0, ['z'] = 5.51, ['text'] = 'Pressione ~y~[E] ~w~para trabalhar na ~y~Transportdora', ['job'] = 'truck-driver'},
}

retorno_loc = vector3(1201.36,-3238.62,6.03)

usaItemDinheiro = false
nomeItemDinheiro = 'dinheiro'

-------------------------------------------------------------------------------------------
-- [ CAMINHONEIRO ] -----------------------------------------------------------------------
-------------------------------------------------------------------------------------------
config_props_truck = {
	[1] = {
		props = {
			{['x'] = 1234.52, ['y'] = -3245.78, ['z'] = 5.51},
			{['x'] = 1234.47, ['y'] = -3247.96, ['z'] = 5.51},
			{['x'] = 1234.46, ['y'] = -3250.09, ['z'] = 5.51},
			{['x'] = 1234.54, ['y'] = -3252.13, ['z'] = 5.51},
		},
		status = false,
		cds = {
			coords = vector3(1244.78,-3225.69,5.93),
			h = 269.87,
			coords2 = vector3(1214.86,-3247.02,4.96),
			h2 = 268.57
		},
	},
	[2] = {
		props = {
			{['x'] = 1235.91, ['y'] = -3254.81, ['z'] = 5.51},
			{['x'] = 1236.1, ['y'] = -3256.81, ['z'] = 5.51},
			{['x'] = 1235.95, ['y'] = -3258.47, ['z'] = 5.51},
			{['x'] = 1236.27, ['y'] = -3260.89, ['z'] = 5.51},
		},
		status = false,
		cds = {
			coords = vector3(1244.76,-3220.24,5.88),
			h = 269.87,
			coords2 = vector3(1214.73,-3249.13,4.96),
			h2 = 268.57
		},
	},
}

config_rotas_transportadora = {
	[1] = {
		['nome'] = 'FIB',
		['cds'] = vector3(2493.13,-447.94,93.0),
		['props'] = {
			{vector3(2503.66,-441.12,93.0),status = false},
			{vector3(2503.37,-443.91,93.0),status = false},
			{vector3(2503.74,-435.36,93.0),status = false},
			{vector3(2503.74,-432.24,93.0),status = false},
		},
		['forkLift'] = {
			cds = vector3(2488.6,-438.14,93.0),
			h = 181.23
		},
		['pagamento'] = {
			valorMinimo = 1000,
			valorMaximo = 2000
		},
	},
	[2] = {
		['nome'] = 'Jetsam',
		['cds'] = vector3(-804.81,-2657.47,13.82),
		['props'] = {
			{vector3(-825.28,-2635.71,15.45),status = false},
			{vector3(-823.45,-2637.07,15.45),status = false},
			{vector3(-821.6,-2638.55,15.45),status = false},
			{vector3(-819.26,-2640.42,15.45),status = false},
		},
		['forkLift'] = {
			cds = vector3(-821.09,-2646.11,13.27),
			h = 239.98
		},
		['pagamento'] = {
			valorMinimo = 800,
			valorMaximo = 1600
		},
	},
	[3] = {
		['nome'] = 'Supermercado Sandy Shores',
		['cds'] = vector3(1694.33,4798.86,41.87),
		['props'] = {
			{vector3(1701.6,4808.38,41.86),status = false},
			{vector3(1704.05,4807.71,41.84),status = false},
			{vector3(1707.34,4807.54,41.83),status = false},
			{vector3(1710.17,4807.59,41.83),status = false},
		},
		['forkLift'] = {
			cds = vector3(1725.83,4802.96,41.16),
			h = 89.24
		},
		['pagamento'] = {
			valorMinimo = 1500,
			valorMaximo = 2700,
		},
	},
	[4] = {
		['nome'] = 'Supermercado Paleto Bay',
		['cds'] = vector3(-71.33,6553.15,31.5),
		['props'] = {
			{vector3(-72.29,6542.89,31.5),status = false},
			{vector3(-74.66,6540.91,31.5),status = false},
			{vector3(-76.69,6538.75,31.5),status = false},
			{vector3(-79.57,6536.61,31.5),status = false},
		},
		['forkLift'] = {
			cds = vector3(-85.24,6541.14,30.95),
			h = 315.86
		},
		['pagamento'] = {
			valorMinimo = 1500,
			valorMaximo = 2700
		},
	},
	[5] = {
		['nome'] = 'Restaurante Los Santos',
		['cds'] = vector3(-841.12,-1147.29,6.86),
		['props'] = {
			{vector3(-844.52,-1122.81,7.07),status = false},
			{vector3(-845.27,-1120.59,7.07),status = false},
			{vector3(-847.22,-1117.98,7.07),status = false},
			{vector3(-849.31,-1115.34,7.07),status = false},
		},
		['forkLift'] = {
			cds = vector3(-848.68,-1135.38,6.37),
			h = 211.48
		},
		['pagamento'] = {
			valorMinimo = 800,
			valorMaximo = 1600
		},
	},
	[6] = {
		['nome'] = 'Cassino',
		['cds'] = vector3(974.56,2.39,81.0),
		['props'] = {
			{vector3(971.58,8.75,81.0),status = false},
			{vector3(972.95,11.16,81.0),status = false},
			{vector3(974.83,14.06,81.0),status = false},
			{vector3(976.35,17.28,81.0),status = false},
		},
		['forkLift'] = {
			cds = vector3(981.59,4.47,80.45),
			h = 56.6
		},
		['pagamento'] = {
			valorMinimo = 1000,
			valorMaximo = 1800,
		},
	},
	[7] = {
		['nome'] = 'Hospital',
		['cds'] = vector3(351.13,-543.94,28.75),
		['props'] = {
			{vector3(343.57,-561.82,28.75),status = false},
			{vector3(341.98,-561.28,28.75),status = false},
			{vector3(339.51,-560.64,28.75),status = false},
			{vector3(337.16,-559.87,28.75),status = false},
		},
		['forkLift'] = {
			cds = vector3(321.33,-555.68,28.2),
			h = 341.331
		},
		['pagamento'] = {
			valorMinimo = 900,
			valorMaximo = 1800
		},
	},
	[8] = {
		['nome'] = 'Big Goods',
		['cds'] = vector3(856.9,-918.49,25.92),
		['props'] = {
			{vector3(850.62,-906.03,25.25),status = false},
			{vector3(853.06,-905.78,25.31),status = false},
			{vector3(855.09,-906.23,25.37),status = false},
			{vector3(857.28,-906.18,25.44),status = false},
		},
		['forkLift'] = {
			cds = vector3(850.7,-902.49,24.72),
			h = 271.02
		},
		['pagamento'] = {
			valorMinimo = 1000,
			valorMaximo = 1800
		},
	},
	[9] = {
		['nome'] = 'Go Postal',
		['cds'] = vector3(61.51,106.4,79.07),
		['props'] = {
			{vector3(60.47,128.66,79.23),status = false},
			{vector3(62.75,127.54,79.21),status = false},
			{vector3(65.56,126.41,79.18),status = false},
			{vector3(68.38,125.46,79.19),status = false},
		},
		['forkLift'] = {
			cds = vector3(75.18,123.84,78.67),
			h = 156.8
		},
		['pagamento'] = {
			valorMinimo = 1000,
			valorMaximo = 1800
		},
	},
	[10] = {
		['nome'] = 'Split Sides West',
		['cds'] = vector3(-412.08,250.8,83.16),
		['props'] = {
			{vector3(-426.27,290.24,83.23),status = false},
			{vector3(-425.91,292.86,83.23),status = false},
			{vector3(-425.88,295.4,83.23),status = false},
			{vector3(-425.29,297.4,83.23),status = false},
		},
		['forkLift'] = {
			cds = vector3(-408.02,287.17,82.69),
			h = 82.14
		},
		['pagamento'] = {
			valorMinimo = 1200,
			valorMaximo = 2200
		},
	},
}