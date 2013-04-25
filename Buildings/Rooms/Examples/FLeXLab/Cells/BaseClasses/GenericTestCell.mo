within Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses;
model GenericTestCell
  "Generic model of a test cell. Can be extended to create specific cells"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  //Medium declarations
  replaceable package Air =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Medium model for the fluid in the space";
  replaceable package Water = Buildings.Media.ConstantPropertyLiquidWater
    "Medium model for the fluid in the radiant slab";

  //Segment declarations
  parameter Integer nSegSlab = 10 "Number of segments in the slab";

  //Nominal condition declarations
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_slab = 0.06
    "Nominal mass flow rate through the slab";

  //Emissivity declarations
  parameter Real SlabEmissivity = 0.88 "Emissivity of the radiant slab";

  //Wall number declarations
  parameter Integer nConExtWin = 1
    "Number of walls using the construction conExtWin";

  Rooms.MixedAir roo(
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    nPorts=2,
    nConBou=0,
    redeclare package Medium = Air,
    nConExt=0,
    nConExtWin=0,
    nConPar=0,
    hRoo=2.7,
    nSurBou=1,
    lat=0.78539816339745,
    AFlo=60.97)
    annotation (Placement(transformation(extent={{-18,70},{22,110}})));
  Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    pipe=pipe,
    m_flow_nominal=m_flow_nominal_slab,
    layers=slaCon,
    redeclare package Medium = Water,
    disPip=0.2,
    A=60.97)
    annotation (Placement(transformation(extent={{-16,14},{4,34}})));           //Gr = emissivity * A * view factor. Per pg 79 of Introduction to Cold Regions Engineering (Dean Freitag, Terry McFadden) view factor for a floor to a room = 1 (assuming no windows)
  HeatTransfer.Sources.PrescribedTemperature preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-10})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(table=[0,288.15; 86400,288.15])
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-42})));
  Fluid.Sources.MassFlowSource_T watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-70,14},{-50,34}})));
  Fluid.Sources.Boundary_pT watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,24})));
  Modelica.Blocks.Sources.CombiTimeTable watCon(table=[0,0.06,303.15; 86400,0.06,
        303.15]) "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-126,18},{-106,38}})));
  HeatTransfer.Data.OpaqueConstructions.Generic slaCon(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1524,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.127,
        k=0.036,
        c=1200,
        d=40),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)}) "Construction of the slab"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
               //fixme - Don't actually know width thickness of reinforced concrete foundation (3rd layer)

  Fluid.Data.Pipes.PEX_RADTEST pipe
    annotation (Placement(transformation(extent={{120,-2},{140,18}})));
                 //fixme - Is it legit to use this model for air gap (2nd layer)? Probably b/c partition wall (only care about thermal mass, not heat transfer)

  //fixme - Roof construction is completely made up. Inadequate information available, only know that insulation is R20. Currently 1/2" plywood => R20 insul => 1/2 in steel sheeting

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-10,160},{10,180}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(table=[0,0,1,0; 86400,0,1,0])
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-140,108},{-120,128}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(table=[0,1; 86400,1])
    "Position of the shade"
    annotation (Placement(transformation(extent={{-106,138},{-86,158}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-98,108},{-78,128}})));
  Fluid.Sources.MassFlowSource_T airIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air) "Inlet air conditions (from AHU)"
    annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
  Fluid.Sources.Boundary_pT airOut(nPorts=1, redeclare package Medium = Air)
    annotation (Placement(transformation(extent={{-112,54},{-92,74}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(table=[0,0.1,293.15; 86400,0.1,293.15])
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-168,84},{-148,104}})));

  //Do not currently have details on window construction. For now this is a generic window placeholder
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    annotation (Placement(transformation(extent={{-62,138},{-42,158}})));
equation
  connect(TGro.y[1], preT.T)                            annotation (Line(
      points={{-2,-31},{-2,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{4,24},{32,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn.ports[1], sla.port_a)    annotation (Line(
      points={{-50,24},{-16,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in)             annotation (Line(
      points={{-105,28},{-96,28},{-96,32},{-70,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in)             annotation (Line(
      points={{-105,28},{-72,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_b, preT.port)                  annotation (Line(
      points={{-2,14},{-2,0}},
      color={191,0,0},
      smooth=Smooth.None));
  //fixme - Have multiple exterior construction. One for roof, one for walls. Need to modify room model to use both?
  //fixme - Can't find detailed information on windows in drawings. Windows specs stated in requirements spreadsheet (ASHRAE compliant). Have location information. Going to work with what's available for now
  //fixme - uSha input seems to have no impact in either this model or in Buildings.Rooms.MixedAir.Examples.MixedAirFreeResponse. Both are set to have Az = S so sun should shine through...right?
  //fixme - Currently N wall is not modeled. Ran out of constructions (conExt for roof, conExtWin for S, need one for heavily insulated N and one for less insulated N). What if assume that roof is adiabatic?

  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{10,170},{19.9,170},{19.9,107.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(intGai.y[1], multiplex3_1.u1[1]) annotation (Line(
      points={{-119,118},{-112,118},{-112,125},{-100,125}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[2], multiplex3_1.u2[1]) annotation (Line(
      points={{-119,118},{-100,118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[3], multiplex3_1.u3[1]) annotation (Line(
      points={{-119,118},{-112,118},{-112,111},{-100,111}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-77,118},{-50,118},{-50,100},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], roo.ports[1]) annotation (Line(
      points={{-90,90},{-40,90},{-40,80},{-15,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airOut.ports[1], roo.ports[2]) annotation (Line(
      points={{-92,64},{-40,64},{-40,80},{-11,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-147,94},{-128,94},{-128,98},{-110,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-147,94},{-112,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaPos.y[1], replicator.u) annotation (Line(
      points={{-85,148},{-64,148}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, roo.uSha) annotation (Line(
      points={{-41,148},{-34,148},{-34,106},{-20,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, roo.surf_surBou[1]) annotation (Line(
      points={{-2,34},{-2,55},{-2,76},{-1.8,76}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end GenericTestCell;
