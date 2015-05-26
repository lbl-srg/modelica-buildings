within Buildings.OpenStudioToModelica.PrototypeBuilding;
model SmallOfficeBuilding
  "Small office building automatically converted from OpenStudio/EnergyPlus to Modelica"
  extends Buildings.OpenStudioToModelica.Interfaces.BaseBuilding(nRooms=6);

  // MATERIALS
  parameter Buildings.HeatTransfer.Data.Solids.Generic  MAT__d__CC05_4_HW_CONCRETE(
    x=0.1016, k=1.311, c=836.8, d=2240.0, nStaRef=nStaRef)
    "Material opaque with mass MAT__d__CC05_4_HW_CONCRETE" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Resistances.Generic CP02_CARPET_PAD(R=0.2165)
    "Material opaque with no masss CP02_CARPET_PAD" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  GP01_1__2_GYPSUM(
    x=0.0127, k=0.16, c=1090.0, d=800.0, nStaRef=nStaRef)
    "Material opaque with mass GP01_1__2_GYPSUM" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Resistances.Generic Std_CP02_CARPET_PAD(R=0.21648)
    "Material opaque with no masss Std_CP02_CARPET_PAD" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  Std_MAT__d__CC05_4_MW_CONCRETE(
    x=0.1, k=0.858, c=836.8, d=1968.0, nStaRef=nStaRef)
    "Material opaque with mass Std_MAT__d__CC05_4_MW_CONCRETE" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  _1IN_Stucco(
    x=0.0253, k=0.6918, c=837.0, d=1858.0, nStaRef=nStaRef)
    "Material opaque with mass _1IN_Stucco" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  _8IN_Concrete_HW(
    x=0.2033, k=1.7296, c=837.0, d=2243.0, nStaRef=nStaRef)
    "Material opaque with mass _8IN_Concrete_HW" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  Wall_Insulation___5__(
    x=0.0453, k=0.0432, c=837.0, d=91.0, nStaRef=nStaRef)
    "Material opaque with mass Wall_Insulation___5__" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  _1__2IN_Gypsum(
    x=0.0127, k=0.16, c=830.0, d=784.9, nStaRef=nStaRef)
    "Material opaque with mass _1__2IN_Gypsum" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Glasses.Generic Theoretical_Glass___67__(
    x=0.003, k=0.0199, tauSol=0.4826, rhoSol_a=0.3284, rhoSol_b=0.3284,
    tauIR=0.0, absIR_a=0.9, absIR_b=0.9)
    "Material glass Theoretical_Glass___67__" annotation(Dialog(tab = "Materials", group="Glazing"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  Floor_Insulation___2__(
    x=0.0636, k=0.045, c=836.8, d=265.0, nStaRef=nStaRef)
    "Material opaque with mass Floor_Insulation___2__" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  MAT__d__CC05_8_HW_CONCRETE(
    x=0.2032, k=1.311, c=836.8, d=2240.0, nStaRef=nStaRef)
    "Material opaque with mass MAT__d__CC05_8_HW_CONCRETE" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  Wood_Shingles(
    x=0.0178, k=0.115, c=1255.0, d=513.0, nStaRef=nStaRef)
    "Material opaque with mass Wood_Shingles" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  _1IN_Wood_Decking(
    x=0.0254, k=0.1211, c=2510.0, d=593.0, nStaRef=nStaRef)
    "Material opaque with mass _1IN_Wood_Decking" annotation(Dialog(tab = "Materials", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.Solids.Generic  Roof_Insulation___2__(
    x=0.2216, k=0.049, c=836.8, d=265.0, nStaRef=nStaRef)
    "Material opaque with mass Roof_Insulation___2__" annotation(Dialog(tab = "Materials", group="Opaque"));

  // CONSTRUCTIONS
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic ext__d__slab(
    final nLay = 2,
    absIR_a = 0.7, absIR_b = 0.8,
    absSol_a = 0, absSol_b = 0,
    material = {
      MAT__d__CC05_4_HW_CONCRETE, CP02_CARPET_PAD}) "Construction ext__d__slab"
                                annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic int__d__walls(
    final nLay = 2,
    absIR_a = 0.5, absIR_b = 0.5,
    absSol_a = 0, absSol_b = 0,
    material = {
      GP01_1__2_GYPSUM, GP01_1__2_GYPSUM}) "Construction int__d__walls"
                                 annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic INT__d__FLOOR__d__UNDERSIDE(
    final nLay = 2,
    absIR_a = 0.8, absIR_b = 0.2,
    absSol_a = 0, absSol_b = 0,
    material = {
      Std_CP02_CARPET_PAD, Std_MAT__d__CC05_4_MW_CONCRETE})
    "Construction INT__d__FLOOR__d__UNDERSIDE" annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic ext__d__walls(
    final nLay = 4,
    absIR_a = 0.92, absIR_b = 0.92,
    absSol_a = 0, absSol_b = 0,
    material = {
      _1IN_Stucco, _8IN_Concrete_HW, Wall_Insulation___5__, _1__2IN_Gypsum})
    "Construction ext__d__walls" annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic window_north(
    absIRFra = 0.04999999999999993, absSolFra = 0.04999999999999993, UFra = 0,
    final glass = {
      Theoretical_Glass___67__},
    haveExteriorShade = false, haveInteriorShade = false)
    "Construction glazing window_north"
                                       annotation(Dialog(tab = "Construction", group="Glazing"));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic window_west(
    absIRFra = 0.04999999999999993, absSolFra = 0.04999999999999993, UFra = 0,
    final glass = {
      Theoretical_Glass___67__},
    haveExteriorShade = false, haveInteriorShade = false)
    "Construction glazing window_west"
                                      annotation(Dialog(tab = "Construction", group="Glazing"));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic window_east(
    absIRFra = 0.04999999999999993, absSolFra = 0.04999999999999993, UFra = 0,
    final glass = {
      Theoretical_Glass___67__},
    haveExteriorShade = false, haveInteriorShade = false)
    "Construction glazing window_east"
                                      annotation(Dialog(tab = "Construction", group="Glazing"));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.Generic window_south(
    absIRFra = 0.04999999999999993, absSolFra = 0.04999999999999993, UFra = 0,
    final glass = {
      Theoretical_Glass___67__},
    haveExteriorShade = false, haveInteriorShade = false)
    "Construction glazing window_south"
                                       annotation(Dialog(tab = "Construction", group="Glazing"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic INT__d__FLOOR__d__TOPSIDE(
    final nLay = 2,
    absIR_a = 0.2, absIR_b = 0.8,
    absSol_a = 0, absSol_b = 0,
    material = {
      Std_MAT__d__CC05_4_MW_CONCRETE, Std_CP02_CARPET_PAD})
    "Construction INT__d__FLOOR__d__TOPSIDE" annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic exposed__d__floor(
    final nLay = 3,
    absIR_a = 0.7, absIR_b = 0.8,
    absSol_a = 0, absSol_b = 0,
    material = {
      Floor_Insulation___2__, MAT__d__CC05_8_HW_CONCRETE, CP02_CARPET_PAD})
    "Construction exposed__d__floor" annotation(Dialog(tab = "Construction", group="Opaque"));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic roofs(
    final nLay = 4,
    absIR_a = 0.78, absIR_b = 0.92,
    absSol_a = 0, absSol_b = 0,
    material = {
      Wood_Shingles, _1IN_Wood_Decking, Roof_Insulation___2__, _1__2IN_Gypsum})
    "Construction roofs" annotation(Dialog(tab = "Construction", group="Opaque"));

  // ROOMS
  Buildings.Rooms.MixedAir Core_ZN(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 3.05,
    AFlo = 149.65740000000002,
    nConExt = 0,
    nConExtWin = 0,
    nConBou = 1,
    nSurBou = 5,
    nConPar = 0,
    surBou(
      A = { 25.803,25.803,149.65740000000002,53.9545,53.9545},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { Z_,Z_,F_,Z_,Z_}),
    datConBou(
      layers = { ext__d__slab},
      A = { 149.65740000000002},
      each til = F_),
    linearizeRadiation = linearizeRadiation,
    lat=lat) "Room model Core_ZN associated to EnergyPlus space Core_ZN.";
  Buildings.Rooms.MixedAir Perimeter_ZN_3(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 3.05,
    AFlo = 113.45000000000002,
    nConExt = 0,
    nConExtWin = 1,
    nConBou = 1,
    nSurBou = 4,
    nConPar = 0,
    surBou(
      A = { 21.5667568261897,21.5667568261897,53.9545,113.44999999999999},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { Z_,Z_,Z_,F_}),
    datConBou(
      layers = { ext__d__slab},
      A = { 113.45000000000002},
      each til = F_),
    datConExtWin(
      layers = { ext__d__walls},
      A = { 67.72097999999997},
      glaSys = { window_north},
      wWin = { 16.652699999999992},
      hWin = { 0.7536399502783335},
      fFra = { frame_fra},
      til = { Z_},
      azi = { N_}),
    linearizeRadiation = linearizeRadiation,
    lat=lat)
    "Room model Perimeter_ZN_3 associated to EnergyPlus space Perimeter_ZN_3.";
  Buildings.Rooms.MixedAir Perimeter_ZN_4(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 3.05,
    AFlo = 67.30000000000001,
    nConExt = 0,
    nConExtWin = 1,
    nConBou = 1,
    nSurBou = 4,
    nConPar = 0,
    surBou(
      A = { 67.30000000000001,25.803,21.5667568261897,21.5667568261897},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { F_,Z_,Z_,Z_}),
    datConBou(
      layers = { ext__d__slab},
      A = { 67.30000000000001},
      each til = F_),
    datConExtWin(
      layers = { ext__d__walls},
      A = { 45.14732000000001},
      glaSys = { window_west},
      wWin = { 11.101800000000003},
      hWin = { 0.7536399502783331},
      fFra = { frame_fra},
      til = { Z_},
      azi = { W_}),
    linearizeRadiation = linearizeRadiation,
    lat=lat)
    "Room model Perimeter_ZN_4 associated to EnergyPlus space Perimeter_ZN_4.";
  Buildings.Rooms.MixedAir Perimeter_ZN_2(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 3.05,
    AFlo = 67.30000000000001,
    nConExt = 0,
    nConExtWin = 1,
    nConBou = 1,
    nSurBou = 4,
    nConPar = 0,
    surBou(
      A = { 21.5667568261897,21.5667568261897,67.30000000000001,25.803},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { Z_,Z_,F_,Z_}),
    datConBou(
      layers = { ext__d__slab},
      A = { 67.30000000000001},
      each til = F_),
    datConExtWin(
      layers = { ext__d__walls},
      A = { 45.14732000000001},
      glaSys = { window_east},
      wWin = { 11.101800000000003},
      hWin = { 0.7536399502783331},
      fFra = { frame_fra},
      til = { Z_},
      azi = { E_}),
    linearizeRadiation = linearizeRadiation,
    lat=lat)
    "Room model Perimeter_ZN_2 associated to EnergyPlus space Perimeter_ZN_2.";
  Buildings.Rooms.MixedAir Perimeter_ZN_1(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 3.05,
    AFlo = 113.44999999999999,
    nConExt = 0,
    nConExtWin = 1,
    nConBou = 1,
    nSurBou = 4,
    nConPar = 0,
    surBou(
      A = { 21.5667568261897,113.45000000000002,21.5667568261897,53.9545},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { Z_,F_,Z_,Z_}),
    datConBou(
      layers = { ext__d__slab},
      A = { 113.44999999999999},
      each til = F_),
    datConExtWin(
      layers = { ext__d__walls},
      A = { 63.815759999999976},
      glaSys = { window_south},
      wWin = { 15.692399999999996},
      hWin = { 0.9864045652672635},
      fFra = { frame_fra},
      til = { Z_},
      azi = { S_}),
    linearizeRadiation = linearizeRadiation,
    lat=lat)
    "Room model Perimeter_ZN_1 associated to EnergyPlus space Perimeter_ZN_1.";
  Buildings.Rooms.MixedAir Attic(
    redeclare package Medium = MediumAir,
    energyDynamics = roomEnDyn,
    massDynamics = roomMassDyn,
    intConMod = intConMod,
    extConMod = extConMod,
    hIntFixed = hInternalFixed,
    hExtFixed = hExternalFixed,
    T_start = T_start,
    p_start = p_start,
    X_start = X_start,
    C_start = C_start,
    C_nominal = C_nominal,
    hRoo = 1.4057142857142861,
    AFlo = 567.9774,
    nConExt = 8,
    nConExtWin = 0,
    nConBou = 0,
    nSurBou = 5,
    nConPar = 0,
    surBou(
      A = { 149.65740000000002,67.30000000000001,113.45000000000002,113.44999999999999,67.30000000000001},
      absSol = { abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw,abs_sol_iw},
      absIR = { abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw,abs_ir_iw},
      til = { C_,C_,C_,C_,C_}),
    datConExt(
      layers = { exposed__d__floor,exposed__d__floor,roofs,roofs,exposed__d__floor,exposed__d__floor,roofs,roofs},
      A = { 16.97399999999994,11.436,197.51467018497635,101.86617040494846,16.974,11.43599999999996,197.51467018497638,101.86617040494846},
      til = { C_,C_,2.819536942046688,2.819536942046688,C_,C_,2.819536942046688,2.819536942046688},
      azi = { E_,E_,-1.892852038338002,W_,E_,E_,-1.2487406152517913,E_}),
    linearizeRadiation = linearizeRadiation,
    lat=lat) "Room model Attic associated to EnergyPlus space Attic.";

  // WALLS
  Buildings.HeatTransfer.Conduction.SingleLayer Core_ZN_soil_1(
    A = 149.65740000000002,
    material = soil_material,
    steadyStateInitial = steadyStateInitialWalls,
    T_a_start = T_ground,
    T_b_start = T_ground) "Soil conduction layer connected to room Core_ZN";
  Buildings.HeatTransfer.Conduction.MultiLayer Core_ZN_wall_west(
    A=25.803,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Core_ZN_wall_east(
    A=25.803,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Core_ZN_ceiling(
    A=149.65740000000002,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=INT__d__FLOOR__d__UNDERSIDE,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Core_ZN_wall_south(
    A=53.9545,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Core_ZN_wall_north(
    A=53.9545,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.SingleLayer Perimeter_ZN_3_soil_1(
    A = 113.45000000000002,
    material = soil_material,
    steadyStateInitial = steadyStateInitialWalls,
    T_a_start = T_ground,
    T_b_start = T_ground)
    "Soil conduction layer connected to room Perimeter_ZN_3";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_3_wall_east(
    A=21.5667568261897,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_3_wall_west(
    A=21.5667568261897,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_3_ceiling(
    A=113.44999999999999,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=INT__d__FLOOR__d__UNDERSIDE,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.SingleLayer Perimeter_ZN_4_soil_1(
    A = 67.30000000000001,
    material = soil_material,
    steadyStateInitial = steadyStateInitialWalls,
    T_a_start = T_ground,
    T_b_start = T_ground)
    "Soil conduction layer connected to room Perimeter_ZN_4";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_4_ceiling(
    A=67.30000000000001,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=INT__d__FLOOR__d__UNDERSIDE,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_4_wall_south(
    A=21.5667568261897,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.SingleLayer Perimeter_ZN_2_soil_1(
    A = 67.30000000000001,
    material = soil_material,
    steadyStateInitial = steadyStateInitialWalls,
    T_a_start = T_ground,
    T_b_start = T_ground)
    "Soil conduction layer connected to room Perimeter_ZN_2";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_2_wall_south(
    A=21.5667568261897,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=int__d__walls,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_2_ceiling(
    A=67.30000000000001,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=INT__d__FLOOR__d__UNDERSIDE,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
  Buildings.HeatTransfer.Conduction.SingleLayer Perimeter_ZN_1_soil_1(
    A = 113.44999999999999,
    material = soil_material,
    steadyStateInitial = steadyStateInitialWalls,
    T_a_start = T_ground,
    T_b_start = T_ground)
    "Soil conduction layer connected to room Perimeter_ZN_1";
  Buildings.HeatTransfer.Conduction.MultiLayer Perimeter_ZN_1_ceiling(
    A=113.45000000000002,
    steadyStateInitial = steadyStateInitialWalls,
    final layers=INT__d__FLOOR__d__UNDERSIDE,
    T_a_start=T_wall_start,
    T_b_start=T_wall_start) "Heat conduction through internal opaque constructions, e.g., a partition wall
     that is between two adjacent thermal zones.";
equation
  connect(Core_ZN.surf_conBou[1], Core_ZN_soil_1.port_b);
  connect(Core_ZN_soil_1.port_a, TSoi.port);
  connect(Core_ZN.weaBus, weaBus);
  connect(Core_ZN.surf_surBou[1], Core_ZN_wall_west.port_a);
  connect(Core_ZN.surf_surBou[2], Core_ZN_wall_east.port_a);
  connect(Core_ZN.surf_surBou[3], Core_ZN_ceiling.port_a);
  connect(Core_ZN.surf_surBou[4], Core_ZN_wall_south.port_a);
  connect(Core_ZN.surf_surBou[5], Core_ZN_wall_north.port_a);
  connect(Perimeter_ZN_3.surf_conBou[1], Perimeter_ZN_3_soil_1.port_b);
  connect(Perimeter_ZN_3_soil_1.port_a, TSoi.port);
  connect(Perimeter_ZN_3.weaBus, weaBus);
  connect(Perimeter_ZN_3.surf_surBou[1], Perimeter_ZN_3_wall_east.port_a);
  connect(Perimeter_ZN_3.surf_surBou[2], Perimeter_ZN_3_wall_west.port_a);
  connect(Perimeter_ZN_3.surf_surBou[3], Core_ZN_wall_north.port_b);
  connect(Perimeter_ZN_3.surf_surBou[4], Perimeter_ZN_3_ceiling.port_a);
  connect(Perimeter_ZN_4.surf_conBou[1], Perimeter_ZN_4_soil_1.port_b);
  connect(Perimeter_ZN_4_soil_1.port_a, TSoi.port);
  connect(Perimeter_ZN_4.weaBus, weaBus);
  connect(Perimeter_ZN_4.surf_surBou[1], Perimeter_ZN_4_ceiling.port_a);
  connect(Perimeter_ZN_4.surf_surBou[2], Core_ZN_wall_west.port_b);
  connect(Perimeter_ZN_4.surf_surBou[3], Perimeter_ZN_3_wall_west.port_b);
  connect(Perimeter_ZN_4.surf_surBou[4], Perimeter_ZN_4_wall_south.port_a);
  connect(Perimeter_ZN_2.surf_conBou[1], Perimeter_ZN_2_soil_1.port_b);
  connect(Perimeter_ZN_2_soil_1.port_a, TSoi.port);
  connect(Perimeter_ZN_2.weaBus, weaBus);
  connect(Perimeter_ZN_2.surf_surBou[1], Perimeter_ZN_2_wall_south.port_a);
  connect(Perimeter_ZN_2.surf_surBou[2], Perimeter_ZN_3_wall_east.port_b);
  connect(Perimeter_ZN_2.surf_surBou[3], Perimeter_ZN_2_ceiling.port_a);
  connect(Perimeter_ZN_2.surf_surBou[4], Core_ZN_wall_east.port_b);
  connect(Perimeter_ZN_1.surf_conBou[1], Perimeter_ZN_1_soil_1.port_b);
  connect(Perimeter_ZN_1_soil_1.port_a, TSoi.port);
  connect(Perimeter_ZN_1.weaBus, weaBus);
  connect(Perimeter_ZN_1.surf_surBou[1], Perimeter_ZN_2_wall_south.port_b);
  connect(Perimeter_ZN_1.surf_surBou[2], Perimeter_ZN_1_ceiling.port_a);
  connect(Perimeter_ZN_1.surf_surBou[3], Perimeter_ZN_4_wall_south.port_b);
  connect(Perimeter_ZN_1.surf_surBou[4], Core_ZN_wall_south.port_b);
  connect(Attic.weaBus, weaBus);
  connect(Attic.surf_surBou[1], Core_ZN_ceiling.port_b);
  connect(Attic.surf_surBou[2], Perimeter_ZN_4_ceiling.port_b);
  connect(Attic.surf_surBou[3], Perimeter_ZN_3_ceiling.port_b);
  connect(Attic.surf_surBou[4], Perimeter_ZN_1_ceiling.port_b);
  connect(Attic.surf_surBou[5], Perimeter_ZN_2_ceiling.port_b);
  connect(Core_ZN.qGai_flow, rooms_conn[1].qGai);
  connect(Core_ZN.ports, rooms_conn[1].ports);
  connect(Perimeter_ZN_3.qGai_flow, rooms_conn[2].qGai);
  connect(Perimeter_ZN_3.ports, rooms_conn[2].ports);
  connect(Perimeter_ZN_4.qGai_flow, rooms_conn[3].qGai);
  connect(Perimeter_ZN_4.ports, rooms_conn[3].ports);
  connect(Perimeter_ZN_2.qGai_flow, rooms_conn[4].qGai);
  connect(Perimeter_ZN_2.ports, rooms_conn[4].ports);
  connect(Perimeter_ZN_1.qGai_flow, rooms_conn[5].qGai);
  connect(Perimeter_ZN_1.ports, rooms_conn[5].ports);
  connect(Attic.qGai_flow, rooms_conn[6].qGai);
  connect(Attic.ports, rooms_conn[6].ports);
annotation(experiment(StopTime=86400.0, tolerance = 1.0e-5),
uses(Modelica(version="3.2.1"), Buildings(version="2.0")),
Documentation(
info = "<html><p>This Modelica model have been generated using the <b>openstudio_to_modelica</b> ruby
    package and using the conversion for the Modelica Buildings library 2.0.<br/>
    The model has been generated starting from the an EnergyPlus/OpenStudio building model.</p>
    <p>The model has the following characteristics:</p>
    
    <p>The model has the following connectors that can be used to directly access
    the air inside of each room and specify the internal heat gains (either convective, radiative,
    or sensible):</p>
    <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><th>Connector</th><th>Modelica name</th><th>EnergyPlus/OpenStudio name</th></tr>
    
    <tr>
    <td><code>rooms_conn[1]</code></td>
    <td>Core_ZN</td>
    <td>Core_ZN</td>
    </tr>
    
    <tr>
    <td><code>rooms_conn[2]</code></td>
    <td>Perimeter_ZN_3</td>
    <td>Perimeter_ZN_3</td>
    </tr>
    
    <tr>
    <td><code>rooms_conn[3]</code></td>
    <td>Perimeter_ZN_4</td>
    <td>Perimeter_ZN_4</td>
    </tr>
    
    <tr>
    <td><code>rooms_conn[4]</code></td>
    <td>Perimeter_ZN_2</td>
    <td>Perimeter_ZN_2</td>
    </tr>
    
    <tr>
    <td><code>rooms_conn[5]</code></td>
    <td>Perimeter_ZN_1</td>
    <td>Perimeter_ZN_1</td>
    </tr>
    
    <tr>
    <td><code>rooms_conn[6]</code></td>
    <td>Attic</td>
    <td>Attic</td>
    </tr>
    
    </table>
    <p>
    Use this model to extend the base class simulation example located at
    <a href=\"Modelica://Buildings/OpenStudioToModelica/Interfaces/SimulationExample\">
    Buildings.OpenStudioToModelica.Interfaces.SimulationExample</a>.
    </p>
    </html>",
revisions="<html>
<ul>
<li>Model generated 23/03/2015 15:05 by openstudio_to_modelica.<br/>
Look here for more info...
</li>
</ul>
</html>"));
end SmallOfficeBuilding;
