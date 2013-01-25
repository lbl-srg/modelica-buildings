within Districts.Electrical.Analog;
package Sources "Package with source models"
  extends Modelica.Icons.SourcesPackage;
  package Examples "Package with example models"
    extends Modelica.Icons.ExamplesPackage;
    model PVConstantLoad "Example for the PV model with constant load"
      import Districts;
      extends Modelica.Icons.Example;
      Districts.Electrical.Analog.Sources.PVSimple pv(A=10) "PV module"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={10,40})));
      Modelica.Electrical.Analog.Basic.Ground ground
        annotation (Placement(transformation(extent={{70,-80},{90,-60}})));
      Modelica.Electrical.Analog.Basic.Resistor res(R=0.5)
        annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=12)
        "Voltage source"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powSen "Power sensor"
        annotation (Placement(transformation(extent={{38,-10},{58,10}})));
      Districts.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
        til=0.34906585039887,
        lat=0.65798912800186,
        azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
        annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
      Districts.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
        til=0.34906585039887,
        lat=0.65798912800186,
        azi=-0.78539816339745) "Direct irradiation on tilted surface"
        annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
      Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
          computeWetBulbTemperature=false, filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-128,90},{-108,110}})));
      Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
        annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
    equation
      connect(pv.p, res.p) annotation (Line(
          points={{0,40},{-20,40},{-20,-40},{0,-40}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(res.n, pv.n) annotation (Line(
          points={{20,-40},{80,-40},{80,40},{20,40}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(ground.p, res.n) annotation (Line(
          points={{80,-60},{80,-40},{20,-40}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sou.p, res.p) annotation (Line(
          points={{0,0},{-20,0},{-20,-40},{0,-40}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sou.n, powSen.pc) annotation (Line(
          points={{20,0},{38,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(powSen.nc, res.n) annotation (Line(
          points={{58,0},{80,0},{80,-40},{20,-40}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(powSen.nv, sou.p) annotation (Line(
          points={{48,-10},{48,-20},{0,-20},{0,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(powSen.pv, powSen.nc) annotation (Line(
          points={{48,10},{58,10},{58,0}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus, HDifTil.weaBus) annotation (Line(
          points={{-108,100},{-80,100}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(weaDat.weaBus, HDirTil.weaBus) annotation (Line(
          points={{-108,100},{-94,100},{-94,60},{-80,60}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(HDifTil.H, G.u1) annotation (Line(
          points={{-59,100},{-52,100},{-52,86},{-42,86}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(HDirTil.H, G.u2) annotation (Line(
          points={{-59,60},{-52,60},{-52,74},{-42,74}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(G.y, pv.G) annotation (Line(
          points={{-19,80},{10,80},{10,52}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
                -100},{100,140}}),      graphics),
        experiment(StopTime=172800, Tolerance=1e-05),
        __Dymola_experimentSetupOutput,
        Documentation(info="<html>
<p>
This model illustrates the use of the photovoltaic model.
The total solar irradiation is computed based
on a weather data file. 
The PV is connected to a circuit that has a constant voltage
source and a resistance.
This voltage source may be a DC grid to which the 
circuit is connected.
The power sensor shows how much electrical power is consumed or fed into the voltage source.
In actual systems, the voltage source may be an AC/DC converter.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
        Commands(file=
              "Resources/Scripts/Dymola/Electrical/Analog/Sources/Examples/PVConstantLoad.mos"
            "Simulate and plot"),
        Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
    end PVConstantLoad;


  end Examples;

  model PVSimple "Simple PV model"
    extends Modelica.Electrical.Analog.Interfaces.OnePort;
    parameter Modelica.SIunits.Area A "Net surface area";
    parameter Real fAct(min=0, max=1, unit="1") = 0.9
      "Fraction of surface area with active solar cells";
    parameter Real eta(min=0, max=1, unit="1") = 0.12
      "Module conversion efficiency";
    Modelica.Blocks.Interfaces.RealInput G(unit="W/m2")
      "Total solar irradiation per unit area"
       annotation (Placement(transformation(
          origin={0,70},
          extent={{-20,-20},{20,20}},
          rotation=270), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,120})));

    Modelica.SIunits.Power P "Generated electrical power";
  equation
    P = A*fAct*eta*G;
    P = -v*i;
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
          Line(points={{-90,0},{-59,0}}, color={0,0,0}),
          Line(points={{51,0},{90,0}}, color={0,0,0}),
          Text(
            extent={{-150,-104},{150,-64}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-150,70},{-50,20}},
            lineColor={0,0,255},
            textString="+"),
          Text(
            extent={{51,68},{151,18}},
            lineColor={0,0,255},
            textString="-"),
          Polygon(
            points={{-80,-52},{-32,63},{78,63},{29,-52},{-80,-52}},
            smooth=Smooth.None,
            fillColor={205,203,203},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{-69,-45},{-57,-19},{-34,-19},{-45,-45},{-69,-45}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-5,100},{98,136}},
            lineColor={0,0,255},
            textString="G"),
          Polygon(
            points={{-53,-9},{-41,17},{-18,17},{-29,-9},{-53,-9}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-38,27},{-26,53},{-3,53},{-14,27},{-38,27}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-36,-45},{-24,-19},{-1,-19},{-12,-45},{-36,-45}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-20,-9},{-8,17},{15,17},{4,-9},{-20,-9}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-5,27},{7,53},{30,53},{19,27},{-5,27}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{-3,-45},{9,-19},{32,-19},{21,-45},{-3,-45}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{13,-9},{25,17},{48,17},{37,-9},{13,-9}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Polygon(
            points={{28,27},{40,53},{63,53},{52,27},{28,27}},
            smooth=Smooth.None,
            fillColor={6,13,150},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
          Ellipse(
            extent={{-50,50},{50,-50}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-96,0},{-50,0}}, color={0,0,0}),
          Line(points={{50,0},{96,0}}, color={0,0,0}),
          Line(points={{-50,0},{50,0}}, color={0,0,0}),
          Line(points={{-109,20},{-84,20}}, color={160,160,164}),
          Polygon(
            points={{-94,23},{-84,20},{-94,17},{-94,23}},
            lineColor={160,160,164},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid),
          Line(points={{91,20},{116,20}}, color={160,160,164}),
          Text(
            extent={{-109,25},{-89,45}},
            lineColor={160,160,164},
            textString="i"),
          Polygon(
            points={{106,23},{116,20},{106,17},{106,23}},
            lineColor={160,160,164},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{91,45},{111,25}},
            lineColor={160,160,164},
            textString="i"),
          Line(points={{-119,-5},{-119,5}}, color={160,160,164}),
          Line(points={{-124,0},{-114,0}}, color={160,160,164}),
          Line(points={{116,0},{126,0}}, color={160,160,164})}),
      Documentation(revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of a simple photovoltaic array.
fixme: Convert incoming radiation to take tilt and azimuth into account.
</p>
<p>
This model takes as an input the total solar irradiation on the panel.
The electrical connectors are direct current pins.
</p>
<p>
This model computes the power as <i>P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G</i>,
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and
<i>G</i> is the total solar irradiation.
This power is equal to <i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage across the panel and 
<i>i</i> is the current that flows through the panel.
</p>
<p>
To avoid a large voltage across the panel, it is recommended to use this model together
with a model that prescribes the voltage.
See
<a href=\"modelica://Districts.Electrical.Analog.Sources.Examples.PVSimple\">
Districts.Electrical.Analog.Sources.Examples.PVSimple</a>.
</p>
</html>"));
  end PVSimple;

  model WindTurbine
    "Wind turbine with power output based on table as a function of wind speed"
    extends Modelica.Electrical.Analog.Interfaces.TwoPin;
    final parameter Modelica.SIunits.Velocity vIn = table[1,1]
      "Cut-in steady wind speed";
    final parameter Modelica.SIunits.Velocity vOut = table[size(table,1), 1]
      "Cut-out steady wind speed";
    parameter Real scale(min=0)=1
      "Scaling factor, used to easily adjust the power output without changing the table";

    parameter Boolean tableOnFile=false
      "true, if table is defined on file or in function usertab";
    parameter Real table[:,2]=
            [3.5, 0;
             5.5, 0.1;
             12, 0.9;
             14, 1;
             25, 1]
      "Table of generated power (first column is wind speed, second column is power)";
    parameter String tableName="NoName"
      "Table name on file or in function usertab (see documentation)";
    parameter String fileName="NoName" "File where matrix is stored";

    Modelica.Blocks.Interfaces.RealInput vWin(unit="m/s") "Steady wind speed"
       annotation (Placement(transformation(
          origin={0,120},
          extent={{-20,-20},{20,20}},
          rotation=270), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,120})));
    Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Generated power"
      annotation (Placement(transformation(extent={{100,50},{120,70}})));
  protected
    Modelica.Blocks.Tables.CombiTable1Ds per(
      final tableOnFile=tableOnFile,
      final table=cat(1, cat(1, [0, 0], table),
                      [vOut+10*Modelica.Constants.eps, 0;
                       vOut+20*Modelica.Constants.eps, 0]),
      final tableName=tableName,
      final fileName=fileName,
      final columns=2:2,
      final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
      "Performance table that maps wind speed to electrical power output"
      annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
    Storage.BaseClasses.VariableConductor con
      "Conductor, used to interface power with electrical circuit"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));

    Modelica.Blocks.Math.Gain gain(final k=scale)
      "Gain, used to allow a user to easily scale the power"
      annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

  initial equation
  assert(abs(table[1,2]) == 0,
    "First data point of performance table must be at cut-in wind speed,
   and be equal to 0 Watts.
   Received + "   + String(table[1,1]) + " m/s with " + String(table[1,2]) + " Watts");

  equation
    connect(con.p, p) annotation (Line(
        points={{60,4.44089e-16},{-20,4.44089e-16},{-20,0},{-100,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(n, con.n) annotation (Line(
        points={{100,0},{90,0},{90,4.44089e-16},{80,4.44089e-16}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(per.y[1], gain.u) annotation (Line(
        points={{-49,20},{-32,20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(vWin, per.u) annotation (Line(
        points={{8.88178e-16,120},{8.88178e-16,92},{-92,92},{-92,20},{-72,20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(gain.y, con.P) annotation (Line(
        points={{-9,20},{24,20},{24,8},{58,8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(gain.y, P)     annotation (Line(
        points={{-9,20},{24,20},{24,60},{110,60}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}),
          graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            pattern=LinePattern.None,
            fillColor={202,230,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Rectangle(
            extent={{42,46},{46,-52}},
            fillColor={233,233,233},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Rectangle(
            extent={{-42,14},{-38,-84}},
            fillColor={233,233,233},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Polygon(
            points={{-44,12},{-26,-40},{-38,16},{-44,12}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Polygon(
            points={{-38,12},{8,46},{-42,18},{-38,12}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Polygon(
            points={{-42,12},{-90,40},{-38,18},{-42,12}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Polygon(
            points={{40,44},{100,40},{42,50},{40,44}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,0}),
          Polygon(
            points={{-21,-17},{27,17},{-25,-11},{-21,-17}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            origin={29,69},
            rotation=90,
            lineColor={0,0,0}),
          Polygon(
            points={{24,-14},{-20,22},{26,-8},{24,-14}},
            smooth=Smooth.None,
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid,
            origin={32,20},
            rotation=90,
            lineColor={0,0,0}),
          Ellipse(
            extent={{-46,20},{-34,8}},
            lineColor={0,0,0},
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{38,52},{50,40}},
            lineColor={0,0,0},
            fillColor={222,222,222},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-42,134},{-20,108}},
            lineColor={0,0,127},
            textString="v"),
          Text(
            extent={{100,100},{122,74}},
            lineColor={0,0,127},
            textString="P")}),
      Documentation(info="<html>
<p>
Model of a wind turbine whose power is computed as a function of wind-speed as defined in a table.
</p>
<p>
Input to the model is the local wind speed.
The model requires the specification of a table that maps wind speed in meters per second to generated
power <i>P<sub>t</sub></i> in Watts.
The model has a parameter called <code>scale</code> with a default value of one
that can be used to scale the power generated by the wind turbine.
The generated electrical power is 
<p align=\"center\" style=\"font-style:italic;\">
P = P<sub>t</sub> scale = u i,
</p>
<p>
where <i>u</i> is the voltage and <i>i</i> is the current.
For example, the following specification (with default <code>scale=1</code>) of a wind turbine
</p>
<pre>
  WindTurbine_Table tur(
    table=[3.5, 0;
           5.5,   100;    
           12, 900;
           14, 1000;
           25, 1000]) \"Wind turbine\";
</pre>
<p>
yields the performance shown below. In this example, the cut-in wind speed is <i>3.5</i> meters per second,
and the cut-out wind speed is <i>25</i> meters per second,
as entered by the first and last entry of the wind speed column.
Below and above these wind speeds, the generated power is zero.
</p>
<p align=\"center\">
<img src=\"modelica://Districts/Resources/Images/Electrical/Analog/Sources/WindTurbine_Table.png\"/>
</p>
</html>",   revisions="<html>
<ul>
<li>
January 10, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end WindTurbine;
end Sources;
