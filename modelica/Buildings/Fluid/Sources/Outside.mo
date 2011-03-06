within Buildings.Fluid.Sources;
model Outside
  "Boundary that takes weather data, and optionally trace substances, as an input"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Medium.ExtraProperty C[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Evaluate=true,
                Dialog(enable = (not use_C_in) and Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC] if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
          rotation=0)));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-18},{-80,22}})));
protected
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC]
    "Needed to connect to conditional connector";
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(redeclare package Medium
      =        Medium) "Block to compute water vapor concentration";
equation
  // Check medium properties
  Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
    Medium.singleState, true, medium.X, "Boundary_pT");

  // Conditional connectors for trace substances
  connect(C_in, C_in_internal);
  if not use_C_in then
    C_in_internal = C;
  end if;

  // Connections to compute species concentration
  connect(weaBus.pAtm, x_pTphi.p_in);
  connect(weaBus.TDryBul, x_pTphi.T);
  connect(weaBus.relHum, x_pTphi.phi);

  // Assign medium properties
  medium.p = x_pTphi.p_in;
  medium.T = x_pTphi.T;
  medium.Xi = x_pTphi.X[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
  annotation (defaultComponentName="out",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-98,100},{102,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          visible=use_C_in,
          points={{-100,-80},{-60,-80}},
          color={0,0,255}),
        Text(
          visible=use_C_in,
          extent={{-164,-90},{-62,-130}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
    Documentation(info="<html>
<p>
This model describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained 
from weather data. 
</p>
<p>
To use this model, connect weather data from
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a> to the port
<code>weaBus</code> of this model. 
This will cause the medium of this model to be
at the pressure that is obtained from the weather file, and any flow that
leaves this model to be at the temperature and humidity that are obtained
from the weather data.
</p>
<p>If the parameter <code>use_C_in</code> is <code>false</code> (default option), 
the <code>C</code> parameter
is used as the trace substance for flow that leaves the component, and the <code>C_in</code> input connector is disabled; if <code>use_C_in</code> is <code>true</code>, then the <code>C</code> parameter is ignored, and the value provided by the input connector is used instead.</p> 
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
<p>
Since this model computes the water vapor concentration, it
can only be used with a medium model for moist air.
</p>
</html>",
revisions="<html>
<ul>
<li>
Feb. 9, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics));
end Outside;
