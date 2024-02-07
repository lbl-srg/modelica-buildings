within Buildings.Utilities.Plotters.Examples;
model SingleZoneVAVSupply_u
  "Scatter plots for control signal of a single zone VAV controller from ASHRAE Guideline 36"
   extends Modelica.Icons.Example;

  inner Configuration plotConfiguration(samplePeriod=1)     "Plot configuration"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract heaCooConSig
    "Add control signal for heating (with negative sign) and cooling"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Utilities.Plotters.Scatter scaTem(
    title="Temperature setpoints",
    n=2,
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    legend={"THea [degC]","TCoo [degC]"},
    introduction="Set point temperatures as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).")
    "Scatter plot for temperature setpoints"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.UnitConversions.To_degC THea_degC
    "Control signal for heating"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.UnitConversions.To_degC TCoo_degC
    "Control signal for cooling"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Utilities.Plotters.Scatter scaYFan(
    n=1,
    title="Fan control signal",
    legend={"yFan"},
    xlabel="Heating (negative) and cooling (positive) control loop signal",
    introduction="Fan speed as a function of the heating loop signal (from -1 to 0) and
the cooling loop signal (from 0 to +1).")
    "Scatter plot for fan speed"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply setPoiVAV(
    maxHeaSpe=0.7,
    maxCooSpe=1,
    minSpe=0.3,
    TSupDew_max=290.15,
    TSup_max=303.15,
    TSup_min=289.15)
    "Block that computes the setpoints for temperature and fan speed"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(
    k = 273.15 + 28)
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=273.15 + 22)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    duration=900,
    height=-1,
    offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(duration=900,
      startTime=2700)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Controls.OBC.CDL.Integers.Sources.Constant           opeMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "AHU operation mode is occupied"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Controls.OBC.CDL.Reals.Sources.Constant           TZonCooSet(final k=
        273.15 + 24)
    "Zone cooling set point"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Controls.OBC.CDL.Reals.Sources.Constant           TZonHeaSet(final k=
        273.15 + 20)
    "Zone heating set point"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-58,-50},{-40,-50},
          {-40,-6},{-2,-6}},color={0,0,127}));
  connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-58,60},{-52,60},{
          -52,-9},{-2,-9}},
                        color={0,0,127}));
  connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-58,20},{-48,20},{
          -48,-12},{-2,-12}},
                        color={0,0,127}));

  connect(scaTem.x, heaCooConSig.y) annotation (Line(points={{98,-8},{90,-8},{
          90,50},{-18,50}},   color={0,0,127}));
  connect(THea_degC.y, scaTem.y[1]) annotation (Line(points={{62,20},{72,20},{
          72,-0.5},{98,-0.5}},
                        color={0,0,127}));
  connect(TCoo_degC.y, scaTem.y[2]) annotation (Line(points={{62,-10},{70,-10},{
          70,0.5},{98,0.5}},
                           color={0,0,127}));
  connect(setPoiVAV.y, scaYFan.y[1]) annotation (Line(points={{22,-2},{26,-2},{
          26,-50},{98,-50}},
                           color={0,0,127}));
  connect(heaCooConSig.y, scaYFan.x) annotation (Line(points={{-18,50},{90,50},
          {90,-58},{98,-58}},   color={0,0,127}));
  connect(setPoiVAV.TZon, TZon.y) annotation (Line(points={{-2,-3.6},{-44,-3.6},
          {-44,-20},{-58,-20}},
                           color={0,0,127}));
  connect(uHea.y, heaCooConSig.u2) annotation (Line(points={{-58,60},{-52,60},{
          -52,44},{-42,44}},
                         color={0,0,127}));
  connect(uCoo.y, heaCooConSig.u1) annotation (Line(points={{-58,20},{-48,20},{
          -48,56},{-42,56}},
                         color={0,0,127}));
  connect(setPoiVAV.TSupCooSet, TCoo_degC.u) annotation (Line(points={{22,-16},
          {34,-16},{34,-10},{38,-10}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEcoSet, THea_degC.u) annotation (Line(points={{22,
          -10},{30,-10},{30,20},{38,20}}, color={0,0,127}));
  connect(opeMod.y, setPoiVAV.uOpeMod) annotation (Line(points={{-18,80},{-10,
          80},{-10,-1},{-2,-1}}, color={255,127,0}));
  connect(TZonCooSet.y, setPoiVAV.TCooSet) annotation (Line(points={{-58,-80},{
          -48,-80},{-48,-16},{-2,-16}}, color={0,0,127}));
  connect(TZonHeaSet.y, setPoiVAV.THeaSet) annotation (Line(points={{-18,-80},{
          -10,-80},{-10,-19},{-2,-19}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{140,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=3600.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/SingleZoneVAVSupply_u.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
This example demonstrates how to create a scatter plot that shows
for a single zone VAV control logic
the heating and cooling set point temperatures, and the fan speed,
all as a function of the heating and cooling control signal.
The sequence that will be used to plot the sequence diagram is
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply</a>
and shown below.
The plot will be generated in the file <code>plots.html</code>.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/VAVSingleZoneTSupSet.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2022, by Jianjun Hu:<br/>
Replaced the AHU controller with the one based official release version.
</li>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneVAVSupply_u;
