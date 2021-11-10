within Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses;
partial model HVACMultiFloorBuilding
  "Partial model that contains the HVAC and multifloor building model"

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";

  parameter Integer numFlo = 2 "Number of floors";

  final parameter Modelica.SIunits.Volume VRooCor[numFlo] = flo.VRooCor
    "Room volume core";
  final parameter Modelica.SIunits.Volume VRooSou[numFlo] = flo.VRooSou
    "Room volume south";
  final parameter Modelica.SIunits.Volume VRooNor[numFlo] = flo.VRooNor
    "Room volume north";
  final parameter Modelica.SIunits.Volume VRooEas[numFlo] = flo.VRooEas
    "Room volume east";
  final parameter Modelica.SIunits.Volume VRooWes[numFlo] = flo.VRooWes
    "Room volume west";

  final parameter Modelica.SIunits.Area AFloCor[numFlo] = flo.AFloCor "Floor area core";
  final parameter Modelica.SIunits.Area AFloSou[numFlo] = flo.AFloSou "Floor area south";
  final parameter Modelica.SIunits.Area AFloNor[numFlo] = flo.AFloNor "Floor area north";
  final parameter Modelica.SIunits.Area AFloEas[numFlo] = flo.AFloEas "Floor area east";
  final parameter Modelica.SIunits.Area AFloWes[numFlo] = flo.AFloWes "Floor area west";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

  parameter Real ACHCor(final unit="1/h")=6
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=6
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=9
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=6
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=7
    "Design air change per hour west";

  final parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal[numFlo] = ACHCor*VRooCor.*ACHCor_per*conv
    "Design mass flow rate core for each floor";
  final parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal[numFlo] = ACHSou*VRooSou*conv
    "Design mass flow rate south for each floor";
  final parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal[numFlo] = ACHEas*VRooEas*conv
    "Design mass flow rate east for each floor";
  final parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal[numFlo] = ACHNor*VRooNor*conv
    "Design mass flow rate north for each floor";
  final parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal[numFlo] = ACHWes*VRooWes*conv
    "Design mass flow rate west for each floor";

  final parameter Modelica.SIunits.MassFlowRate mVAV_flow_nominal[numFlo, 5]=
    transpose({mSou_flow_nominal, mEas_flow_nominal, mNor_flow_nominal,
    mWes_flow_nominal, mCor_flow_nominal})
    "Design mass flow rate of each zone";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")=45 + 273.15
    "Reheat coil nominal inlet water temperature";

  replaceable Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC hvac[numFlo]
    constrainedby Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    final VRoo=transpose({VRooSou,VRooEas,VRooNor,VRooWes,VRooCor}),
    final AFlo=transpose({AFloSou,AFloEas,AFloNor,AFloWes,AFloCor}),
    final mVAV_flow_nominal=mVAV_flow_nominal,
    final m_flow_nominal={0.7*sum(mVAV_flow_nominal[i]) for i in 1:numFlo},
    each final THotWatInl_nominal=THotWatInl_nominal) "HVAC system"
    annotation (Placement(transformation(extent={{-48,-28},{40,22}})));

  replaceable Buildings.Examples.VAVReheat.BaseClasses.PartialFloor flo[numFlo] constrainedby
    Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(redeclare final
      package Medium =                                                                     MediumA)
    "Building floors"
    annotation (Placement(transformation(extent={{20,38},{94,82}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
   filNam=weaName, computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=THotWatInl_nominal,
    nPorts=numFlo)
              "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-80})));
  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=numFlo)
              "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-80})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=numFlo)
              "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-80})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=285.15,
    nPorts=numFlo)
              "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-80})));
  Buildings.Fluid.Sources.Boundary_pT souHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THotWatInl_nominal,
    nPorts=numFlo)
              "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-80})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000,
    T=THotWatInl_nominal,
    nPorts=numFlo)
              "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-80})));
protected
  parameter Real ACHCor_per[numFlo] = {0.95 + 0.1*(i - 1)/(numFlo - 1) for i in 1:numFlo} "Perturbation in the core zone design air change";
  // The ACHCor is perturbed so that the floors evolve with different state trajectories
equation
  for fl in 1:numFlo loop
    connect(weaDat.weaBus, hvac[fl].weaBus) annotation (Line(
      points={{-70,10},{-60,10},{-60,11.4444},{-42.225,11.4444}},
      color={255,204,51},
      thickness=0.5));
    connect(weaDat.weaBus, flo[fl].weaBus) annotation (Line(
        points={{-70,10},{-60,10},{-60,86},{66.6522,86},{66.6522,93}},
        color={255,204,51},
        thickness=0.5));
  end for;

  connect(souHea.ports, hvac.portHeaCoiSup) annotation (Line(points={{-80,-70},
          {-80,-40},{-23.25,-40},{-23.25,-28}},color={0,127,255}));
  connect(sinHea.ports, hvac.portHeaCoiRet) annotation (Line(points={{-50,-70},
          {-50,-50},{-15,-50},{-15,-28}},color={0,127,255}));
  connect(souCoo.ports, hvac.portCooCoiSup) annotation (Line(points={{-20,-70},
          {-20,-60},{-4,-60},{-4,-28}},color={0,127,255}));
  connect(sinCoo.ports, hvac.portCooCoiRet) annotation (Line(points={{20,-70},{
          20,-60},{4.25,-60},{4.25,-28}},
                                       color={0,127,255}));
  connect(souHeaTer.ports, hvac.portHeaTerSup) annotation (Line(points={{50,-70},
          {50,-50},{15.25,-50},{15.25,-28}}, color={0,127,255}));
  connect(sinHeaTer.ports, hvac.portHeaTerRet) annotation (Line(points={{80,-70},
          {80,-40},{23.5,-40},{23.5,-28}}, color={0,127,255}));
  connect(flo.TRooAir, hvac.TRoo) annotation (Line(points={{95.6087,61.8333},{
          98,61.8333},{98,90},{-54,90},{-54,16.4444},{-50.75,16.4444}},
                                                                     color={0,0,
          127}));
  connect(hvac.port_supAir[1], flo.portsSou[1]) annotation (Line(points={{40.275,
          19.2222},{42,19.2222},{42,20},{60,20},{60,48},{47.0261,48},{47.0261,
          48.2667}},
        color={0,127,255}));
  connect(hvac.port_supAir[2], flo.portsEas[1]) annotation (Line(points={{40.275,
          19.2222},{42,19.2222},{42,20},{78,20},{78,62.9333},{83.7043,62.9333}},
        color={0,127,255}));
  connect(hvac.port_supAir[3], flo.portsNor[1]) annotation (Line(points={{40.275,
          19.2222},{42,19.2222},{42,20},{72,20},{72,76},{47.0261,76},{47.0261,
          75.4}},
        color={0,127,255}));
  connect(hvac.port_supAir[4], flo.portsWes[1]) annotation (Line(points={{40.275,
          19.2222},{42,19.2222},{42,20},{50,20},{50,32},{38,32},{38,62.9333},{
          27.0783,62.9333}},
                     color={0,127,255}));
  connect(hvac.port_supAir[5], flo.portsCor[1]) annotation (Line(points={{40.275,
          19.2222},{42,19.2222},{42,20},{66,20},{66,62},{47.0261,62},{47.0261,
          62.9333}},
        color={0,127,255}));
  connect(hvac.port_retAir[1], flo.portsSou[2]) annotation (Line(points={{40.275,
          -4.38889},{40.275,-4},{58,-4},{58,48},{50.2435,48},{50.2435,48.2667}},
        color={0,127,255}));
  connect(hvac.port_retAir[2], flo.portsEas[2]) annotation (Line(points={{40.275,
          -4.38889},{40.275,-4},{76,-4},{76,62.9333},{86.9217,62.9333}}, color={
          0,127,255}));
  connect(hvac.port_retAir[3], flo.portsNor[2]) annotation (Line(points={{40.275,
          -4.38889},{42,-4.38889},{42,-4},{70,-4},{70,76},{50.2435,76},{50.2435,
          75.4}}, color={0,127,255}));
  connect(hvac.port_retAir[4], flo.portsWes[2]) annotation (Line(points={{40.275,
          -4.38889},{40.275,-4},{48,-4},{48,30},{36,30},{36,62.9333},{30.2957,
          62.9333}},
        color={0,127,255}));
  connect(hvac.port_retAir[5], flo.portsCor[2]) annotation (Line(points={{40.275,
          -4.38889},{40.275,-4},{64,-4},{64,62},{50.2435,62},{50.2435,62.9333}},
        color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>
Partial model that contains <code>numFlo</code> air handlers connected
to <code>numFlo</code> floors with five conditioned thermal zones each.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HVACMultiFloorBuilding;
