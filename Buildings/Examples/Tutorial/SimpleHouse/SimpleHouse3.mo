within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse3 "Air model"
  extends SimpleHouse2;

  parameter Modelica.Units.SI.Volume V_zone=8*8*3 "Zone volume";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=1
    "Nominal mass flow rate for air loop";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer h_wall=2
    "Convective heat transfer coefficient at the wall";

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Thermal resistance for convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={130,20})));
  Buildings.Fluid.MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mAir_flow_nominal)
    "Very simple zone air model"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{130,10},{130,1.77636e-15},{140,1.77636e-15}},
                                                            color={191,0,0}));
  connect(zone.heatPort, convRes.port_a)
    annotation (Line(points={{110,140},{130,140},{130,30}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
    experiment(Tolerance=1e-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
To increase the model detail we now add an air model assuming the zone is <i>8m</i> x <i>8m</i> x <i>3m</i> in size.
The air will exchange heat with the wall.
This may be modelled using a thermal resistance representing
the convective heat resistance which is equal to <i>R<sub>conv</sub>=1/(h*A)</i>,
where <i>A</i> is the heat exchange surface area and <i>h=2 W/(m<sup>2</sup>*K)</i> is the convective heat transfer coefficient.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>
</li>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">
Modelica.Thermal.HeatTransfer.Components.ThermalResistor</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
The <code>MixingVolume</code> <i>Medium</i> parameter contains information about
the type of fluid and its properties that should be modelled by the <code>MixingVolume</code>.
Set its value to <i>MediumAir</i>, which is declared in the template,
by typing <i>redeclare package Medium = MediumAir</i>.
For the nominal mass flow rate you may assume a value of <i>1 kg/m<sup>3</sup></i> for now.
You will have to change this value once you add a ventilation system to the model (see
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse6\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse6</a>).
Finally, set the <i>energyDynamics</i> of the <code>MixingVolume</code>,
which can be found in the <i>Dynamics</i> tab of the model parameter window, to <i>FixedInitial</i>.
</p>
<p>
Make a connection with the <code>PrescribedHeatFlow</code> as well.
This block makes the connection between the heat flow from the gain, represented as a real value,
and a heat port that is compatible with the connectors of the thermal capacitance and resistance.
</p>
<h4>Reference result</h4>
<p>
The result with and without the air model is plotted in the figure below.
</p>
<p align=\"center\">
<img alt=\"Wall temperature as function of time, with (green) and without (blue) air model.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result3.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse3.mos"
        "Simulate and plot"));
end SimpleHouse3;
