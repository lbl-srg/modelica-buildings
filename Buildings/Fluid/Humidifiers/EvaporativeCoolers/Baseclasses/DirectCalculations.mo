within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block DirectCalculations
  "Calculates efficiency of at given indoor and outdoor wet bulb and dry buld temperatures"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component";
  parameter Modelica.Units.SI.Area PadArea = 1 "Area of the wetted pad";

  parameter Modelica.Units.SI.Length Depth = 0.5 "Depth of the evaporative cooler";

  Modelica.Blocks.Interfaces.RealInput TDryBulSupIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the supply air at the inlet"
      annotation (Placement(
      visible=true,
      transformation(
        origin={-118,20},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,32},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput TWetBulSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the supply air"
      annotation (Placement(
      visible=true,
      transformation(
        origin={-120,52},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-118,82},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput eff(final unit="K/K")
  "Evaporative humidifier efficiency"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={110,72},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,70},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TDryBulSupOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the supply air at the outlet"
      annotation (Placement(
      visible=true,
      transformation(
        origin={110,52},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-32},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Interfaces.RealInput V_flow(unit="m3/s")
  "Air volume flow rate"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={-120,-8},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-18},
        extent={{-20,-20},{20,20}},
        rotation=0)));
  Real Vel "Air volume flow rate per unit pad area";
  Modelica.Blocks.Interfaces.RealOutput m_flowWOut(unit="kg/s")
  "Water vapor mass flow rate at the outlet"
    annotation (
      Placement(
      visible=true,
      transformation(
        origin={110,2},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-66},
        extent={{-10,-10},{10,10}},
        rotation=0)));
 // Modelica.Blocks.Interfaces.RealOutput Humidity_Ratio(unit = "kg/kg") annotation (
   // Placement(visible = true, transformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul XiOut(redeclare
      package                                                                                          Medium = Medium)
  "Water vapor mass fraction at the outlet"
    annotation (
      Placement(visible=true, transformation(
        origin={-10,20},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Interfaces.RealInput p(unit="m3/s")
  "Pressure"
    annotation (Placement(
      visible=true,
      transformation(
        origin={-120,-48},
        extent={{-20,-20},{20,20}},
        rotation=0),
      iconTransformation(
        origin={-120,-66},
        extent={{-20,-20},{20,20}},
        rotation=0)));
//   Real density(unit = "m3/s");
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul XiIn(redeclare
      package                                                                                         Medium = Medium)
  "Water vapor mass fraction at the inlet"
  annotation (
      Placement(visible=true, transformation(
        origin={-10,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));
 Modelica.Blocks.Interfaces.RealOutput dm_flowW(unit="kg/s")
 "Water vapor mass flow rate difference between inlet and outlet
  "
   annotation (
      Placement(
      visible=true,
      transformation(
        origin={110,-54},
        extent={{-10,-10},{10,10}},
        rotation=0),
      iconTransformation(
        origin={110,-94},
        extent={{-10,-10},{10,10}},
        rotation=0)));

parameter Modelica.Units.SI.Density density =  1.225 "Air density";

 //equations start  here
    //Humidity_Ratio = (Mass_WVP)/(Vol_Flow*density + 1e-6);
  // Calculate Saturation efficiency
  // Calculate Dry bulb temp exiting sum
equation
  Vel =V_flow/PadArea;
  eff = 0.792714 + 0.958569*(Depth) - 0.25193*(Vel) - 1.03215*(Depth^2) +
    0.0262659*(Vel^2) + 0.914869*(Depth*Vel) - 1.48241*(Vel*Depth^2) - 0.018992
    *(Depth*Vel^3) + 1.13137*(Depth^3*Vel) + 0.0327622*(Vel^3*Depth^2) -
    0.145384*(Depth^3*Vel^2);
  TDryBulSupOut =TDryBulSupIn - eff*(TDryBulSupIn - TWetBulSup);
  connect(XiIn.TDryBul, TDryBulSupIn);
  connect(XiIn.TWetBul,TWetBulSup);
  connect(XiIn.p, p);
  connect(XiOut.TDryBul,TDryBulSupOut);
  connect(XiOut.TWetBul,TWetBulSup);
  connect(XiOut.p, p);
  m_flowWOut = XiOut.Xi[1]*V_flow*density;
  dm_flowW = (XiOut.Xi[1] - XiIn.Xi[1])*V_flow*density;
end DirectCalculations;
