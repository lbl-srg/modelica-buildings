within Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses;
model GenericTestCellConditionalConnectionsBETA
  "Generic model of a test cell. Can be extended to create specific cells. Work in progress to use conditional connectors for text file and air/water inputs. Shelved because deemed too gankity/weird/non-robust"
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

  //Conditional connectors
  //User can select to enter data via a text file, or via input connectors (i.e. model AHU and connect to room model via fluid port)
  parameter Boolean use_AirPor = false
    "True = Connect airflow via fluid port, false = reference external data file"
  annotation(Dialog(tab="Conditional connectors"));

  //Input data file declarations
  //fixme - For all input data files state what each column is and units in documentation. Example: TGro has 1 column, ground temperature, in K. Example 2: watCon has two columns: flow (kg/s) and T (K)
  parameter Boolean use_TGro_file = false
    "True = external data file, false = table typed into parameter window"
    annotation(Dialog(tab="Input data", group="Ground temperature"));
  parameter Real TGro_table[:,:] = [0,288.15; 86400,288.15]
    "Default data for TGro"
    annotation(Dialog(tab="Input data", group="Ground temperature",enable = not use_TGro_file));
  parameter String TGroTableName="NoName" "Name of table in TGro file"
    annotation(Dialog(tab="Input data", group="Ground temperature",enable = use_TGro_file));
  parameter String TGroFileName = "NoName"
    "Name and location of TGro text file"
    annotation(Dialog(tab="Input data", group="Ground temperature",enable = use_TGro_file, __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));
  parameter Boolean use_watCon_file = false
    "True = external data file, false = table typed into parameter window"
    annotation(Dialog(tab="Input data", group="Inlet water conditions"));
  parameter Real watCon_table[:,:] = [0, 0.06, 303.15; 86400, 0.06, 303.15]
    "Default data for inlet water conditions"
    annotation(Dialog(tab="Input data", group="Inlet water conditions",enable = not use_watCon_file));
  parameter String watConTableName="NoName" "Name of table in watCon text file"
    annotation(Dialog(tab="Input data", group="Inlet water conditions",enable = use_watCon_file));
  parameter String watConFileName = "NoName"
    "Name and location of watCon text file"
    annotation(Dialog(tab="Input data", group="Inlet water conditions",enable = use_watCon_file, __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));
  parameter Boolean use_airCon_file = false
    "True = external data file, false = table typed into parameter window"
    annotation(Dialog(tab="Input data", group="Inlet air conditions", enable = not use_AirPor));
  parameter Real airCon_table[:,:] = [0, 0.1, 293.15; 86400, 0.1, 293.15]
    "Default data for inlet air conditions"
    annotation(Dialog(tab="Input data", group="Inlet air conditions",enable = not use_airCon_file));
  parameter String airConTableName="NoName" "Name of table in watCon text file"
    annotation(Dialog(tab="Input data", group="Inlet air conditions",enable = use_airCon_file));
  parameter String airConFileName = "NoName"
    "Name and location of airCon text file"
    annotation(Dialog(tab="Input data", group="Inlet air conditions",enable = use_airCon_file, __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));
  parameter Boolean use_intGai_file = false
    "True = external data file, false = table typed into parameter window"
    annotation(Dialog(tab="Input data", group="Internal gains"));
  parameter Real intGai_table[:,:] = [0, 0, 0, 0; 86400, 0, 0, 0]
    "Default data for internal gains"
    annotation(Dialog(tab="Input data", group="Internal gains",enable = not use_intGai_file));
  parameter String intGaiTableName="NoName" "Name of table in intGai text file"
    annotation(Dialog(tab="Input data", group="Internal gains",enable = use_intGai_file));
  parameter String intGaiFileName = "NoName"
    "Name and location of intGai text file"
    annotation(Dialog(tab="Input data", group="Internal gains",enable = use_intGai_file, __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));
  parameter Boolean use_shaPos_file = false
    "True = external data file, false = table typed into parameter window"
    annotation(Dialog(tab="Input data", group="Shade position"));
  parameter Real shaPos_table[:,:] = [0, 1; 86400, 1]
    "Default data for shade position"
    annotation(Dialog(tab="Input data", group="Shade position",enable = not use_shaPos_file));
  parameter String shaPosTableName="NoName" "Name of table in shaPos text file"
    annotation(Dialog(tab="Input data", group="Shade position",enable = use_shaPos_file));
  parameter String shaPosFileName = "NoName"
    "Name and location of shaPos text file"
    annotation(Dialog(tab="Input data", group="Shade position",enable = use_shaPos_file, __Dymola_loadSelector(filter="Text files (*.txt);;Matlab files (*.mat)",
                         caption="Open file in which table is present")));

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
    annotation (Placement(transformation(extent={{-2,4},{38,44}})));
  Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
    iLayPip=1,
    pipe=pipe,
    m_flow_nominal=m_flow_nominal_slab,
    layers=slaCon,
    redeclare package Medium = Water,
    disPip=0.2,
    A=60.97)
    annotation (Placement(transformation(extent={{0,-52},{20,-32}})));          //Gr = emissivity * A * view factor. Per pg 79 of Introduction to Cold Regions Engineering (Dean Freitag, Terry McFadden) view factor for a floor to a room = 1 (assuming no windows)
  HeatTransfer.Sources.PrescribedTemperature preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-76})));
  Modelica.Blocks.Sources.CombiTimeTable TGro(
      tableOnFile=use_TGro_file,
    table=TGro_table,
    tableName=TGroTableName,
    fileName=TGroFileName)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-108})));
  Fluid.Sources.MassFlowSource_T watIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Water)
    "Inlet water conditions (from central plant)"
    annotation (Placement(transformation(extent={{-54,-52},{-34,-32}})));
  Fluid.Sources.Boundary_pT watOut(nPorts=1, redeclare package Medium = Water)
    "Water outlet"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={58,-42})));
  Modelica.Blocks.Sources.CombiTimeTable watCon(
    tableOnFile=use_watCon_file,
    table=watCon_table,
    tableName=watConTableName,
    fileName=watConFileName)
    "Inlet water conditions (y[1] = m_flow, y[2] =  T)"
    annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
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
    annotation (Placement(transformation(extent={{136,-46},{156,-26}})));
               //fixme - Don't actually know width thickness of reinforced concrete foundation (3rd layer)

  Fluid.Data.Pipes.PEX_RADTEST pipe
    annotation (Placement(transformation(extent={{136,-68},{156,-48}})));
                 //fixme - Is it legit to use this model for air gap (2nd layer)? Probably b/c partition wall (only care about thermal mass, not heat transfer)

  //fixme - Roof construction is completely made up. Inadequate information available, only know that insulation is R20. Currently 1/2" plywood => R20 insul => 1/2 in steel sheeting

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{6,94},{26,114}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai(
    tableOnFile=use_intGai_file,
    table=intGai_table,
    tableName=intGaiTableName,
    fileName=intGaiFileName)
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{-124,46},{-104,66}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos(
    tableOnFile=use_shaPos_file,
    table=shaPos_table,
    tableName=shaPosTableName,
    fileName=shaPosFileName) "Position of the shade"
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-82,46},{-62,66}})));
  Fluid.Sources.MassFlowSource_T airIn(
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = Air) if not use_AirPor
    "Inlet air conditions (from AHU)"
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Fluid.Sources.Boundary_pT airOut(nPorts=1, redeclare package Medium = Air)
    annotation (Placement(transformation(extent={{-96,-12},{-76,8}})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(
    tableOnFile=use_airCon_file,
    table=airCon_table,
    tableName=airConTableName,
    fileName=airConFileName) if not use_AirPor
    "Inlet air conditions (y[1] = m_flow, y[2] = T)"
    annotation (Placement(transformation(extent={{-152,22},{-132,42}})));

  //Do not currently have details on window construction. For now this is a generic window placeholder
  Modelica.Blocks.Routing.Replicator replicator(nout=max(1, nConExtWin))
    annotation (Placement(transformation(extent={{-46,74},{-26,94}})));
  Modelica.Fluid.Interfaces.FluidPort_a airPor_a(redeclare package Medium = Air) if use_AirPor
    "Inlet port for air entering room"
    annotation (Placement(transformation(extent={{-210,18},{-190,38}})));
equation
  connect(TGro.y[1], preT.T)                            annotation (Line(
      points={{14,-97},{14,-88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.port_b,watOut. ports[1])    annotation (Line(
      points={{20,-42},{48,-42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watIn.ports[1], sla.port_a)    annotation (Line(
      points={{-34,-42},{0,-42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(watCon.y[1],watIn. m_flow_in)             annotation (Line(
      points={{-89,-38},{-80,-38},{-80,-34},{-54,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watCon.y[2],watIn. T_in)             annotation (Line(
      points={{-89,-38},{-56,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_b, preT.port)                  annotation (Line(
      points={{14,-52},{14,-66}},
      color={191,0,0},
      smooth=Smooth.None));
  //fixme - Have multiple exterior construction. One for roof, one for walls. Need to modify room model to use both?
  //fixme - Can't find detailed information on windows in drawings. Windows specs stated in requirements spreadsheet (ASHRAE compliant). Have location information. Going to work with what's available for now
  //fixme - uSha input seems to have no impact in either this model or in Buildings.Rooms.MixedAir.Examples.MixedAirFreeResponse. Both are set to have Az = S so sun should shine through...right?
  //fixme - Currently N wall is not modeled. Ran out of constructions (conExt for roof, conExtWin for S, need one for heavily insulated N and one for less insulated N). What if assume that roof is adiabatic?

  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{26,104},{35.9,104},{35.9,41.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(intGai.y[1], multiplex3_1.u1[1]) annotation (Line(
      points={{-103,56},{-96,56},{-96,63},{-84,63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[2], multiplex3_1.u2[1]) annotation (Line(
      points={{-103,56},{-84,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGai.y[3], multiplex3_1.u3[1]) annotation (Line(
      points={{-103,56},{-96,56},{-96,49},{-84,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, roo.qGai_flow) annotation (Line(
      points={{-61,56},{-34,56},{-34,34},{-4,34}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(airOut.ports[1], roo.ports[2]) annotation (Line(
      points={{-76,-2},{-24,-2},{-24,14},{5,14}},
      color={0,127,255},
      smooth=Smooth.None));
  if not use_AirPor then
  connect(airCon.y[1],airIn. m_flow_in) annotation (Line(
      points={{-131,32},{-112,32},{-112,36},{-94,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airCon.y[2],airIn. T_in) annotation (Line(
      points={{-131,32},{-96,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(airIn.ports[1], roo.ports[1]) annotation (Line(
      points={{-74,28},{-24,28},{-24,14},{1,14}},
      color={0,127,255},
      smooth=Smooth.None));
  else
      connect(airPor_a,roo.ports[1]);
  end if;
  connect(shaPos.y[1], replicator.u) annotation (Line(
      points={{-69,84},{-48,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, roo.uSha) annotation (Line(
      points={{-25,84},{-18,84},{-18,40},{-4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sla.surf_a, roo.surf_surBou[1]) annotation (Line(
      points={{14,-32},{14,10},{14.2,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -150},{200,150}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-150},{200,150}})));
end GenericTestCellConditionalConnectionsBETA;
