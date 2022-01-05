within Buildings.HeatTransfer.Windows.BaseClasses;
model GasConvection
  "Model for heat convection through gas in a window assembly"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D(
     port_a(T(start=293.15)),
     port_b(T(start=293.15)),
     dT(start=0));
  extends Buildings.BaseClasses.BaseIcon;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Buildings.HeatTransfer.Data.Gases.Generic gas
    "Thermophysical properties of gas fill"
   annotation(choicesAllMatching=true);
  parameter Modelica.Units.SI.Area A "Heat transfer area";
  parameter Modelica.Units.SI.Area h(min=0) = sqrt(A) "Height of window";

  parameter Modelica.Units.SI.Angle til(displayUnit="deg")
    "Surface tilt (only 0, 90 and 180 degrees are implemented)";
  parameter Boolean linearize=false "Set to true to linearize emissive power";

  parameter Modelica.Units.SI.Temperature T0=293.15
    "Temperature used to compute thermophysical properties";

  Modelica.Blocks.Interfaces.RealInput u
    "Input connector, used to scale the surface area to take into account an operable shading device"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Units.SI.CoefficientOfHeatTransfer hCon(min=0, start=3)
    "Convective heat transfer coefficient";
  Modelica.Units.SI.HeatFlux q_flow "Convective heat flux";
  Real Nu(min=0) "Nusselt number";
  Real Ra(min=0) "Rayleigh number";

protected
  Modelica.Units.SI.Temperature T_a
    "Temperature used for thermophysical properties at port_a";
  Modelica.Units.SI.Temperature T_b
    "Temperature used for thermophysical properties at port_b";
  Modelica.Units.SI.Temperature T_m
    "Temperature used for thermophysical properties";

  Real deltaNu(min=0.01) = 0.1
    "Small value for Nusselt number, used for smoothing";
  Real deltaRa(min=0.01) = 100
    "Small value for Rayleigh number, used for smoothing";
  final parameter Real cosTil=Modelica.Math.cos(til) "Cosine of window tilt";
  final parameter Real sinTil=Modelica.Math.sin(til) "Sine of window tilt";
  final parameter Boolean isVertical = abs(cosTil) < 10E-10
    "Flag, true if the window is in a wall";
  final parameter Boolean isHorizontal = abs(sinTil) < 10E-10
    "Flag, true if the window is horizontal";
  // Quantities that are only used in linearized model

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hCon0(fixed=false)
    "Convective heat transfer coefficient";
  parameter Real Nu0(fixed=false, min=0) "Nusselt number";
  parameter Real Ra0(fixed=false, min=0) "Rayleigh number";

initial equation
  // This assertion is required to ensure that the default value of
  // in Buildings.HeatTransfer.Data.Gases.Generic is overwritten.
  assert(gas.x > 0, "The gas thickness must be non-negative. Obtained gas.x = " + String(gas.x) + ".
  Check the parameter for the gas thickness of the window model.");

  assert(isVertical or isHorizontal, "Only vertical and horizontal windows are implemented.");

  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

  // Computations that are used in the linearized model only
  Ra0 = Buildings.HeatTransfer.Convection.Functions.HeatFlux.rayleigh(
    x=gas.x,
    rho=Buildings.HeatTransfer.Data.Gases.density(gas=gas, T=T0),
    c_p=Buildings.HeatTransfer.Data.Gases.specificHeatCapacity(gas=gas, T=T0),
    mu=Buildings.HeatTransfer.Data.Gases.dynamicViscosity(gas=gas, T=T0),
    k=Buildings.HeatTransfer.Data.Gases.thermalConductivity(gas=gas, T=T0),
    T_a=T0-5,
    T_b=T0+5,
    Ra_min=100);
  (Nu0, hCon0) = Buildings.HeatTransfer.Windows.BaseClasses.convectionVerticalCavity(
            gas=gas, Ra=Ra0, T_m=T0, dT=10, h=h, deltaNu=deltaNu, deltaRa=deltaRa);

equation
  T_a = port_a.T;
  T_b = port_b.T;
  T_m = (port_a.T+port_b.T)/2;
  if linearize then
    Ra=Ra0;
    Nu=Nu0;
    hCon=hCon0;
    q_flow = hCon0 * dT;
  else
    Ra = Buildings.HeatTransfer.Convection.Functions.HeatFlux.rayleigh(
      x=gas.x,
      rho=Buildings.HeatTransfer.Data.Gases.density(gas, T_m),
      c_p=Buildings.HeatTransfer.Data.Gases.specificHeatCapacity(gas, T_m),
      mu=Buildings.HeatTransfer.Data.Gases.dynamicViscosity(gas, T_m),
      k=Buildings.HeatTransfer.Data.Gases.thermalConductivity(gas, T_m),
      T_a=T_a,
      T_b=T_b,
      Ra_min=100);
    if isVertical then
       (Nu, hCon, q_flow) = Buildings.HeatTransfer.Windows.BaseClasses.convectionVerticalCavity(
              gas=gas, Ra=Ra, T_m=T_m, dT=dT, h=h, deltaNu=deltaNu, deltaRa=deltaRa);
    elseif isHorizontal then
       (Nu, hCon, q_flow) = Buildings.HeatTransfer.Windows.BaseClasses.convectionHorizontalCavity(
              gas=gas, Ra=Ra, T_m=T_m, dT=dT, til=til, sinTil=sinTil, cosTil=cosTil,
              h=h, deltaNu=deltaNu, deltaRa=deltaRa);

    else
       Nu = 0;
       hCon=0;
       q_flow=0;
    end if; // isVertical or isHorizontal
  end if; // linearize
  if homotopyInitialization then
    Q_flow = u*A*homotopy(actual=q_flow,
                          simplified=hCon0*dT);
  else
    Q_flow = u*A*q_flow;
  end if;
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,78},{-76,-80}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-51,42},{-21,20}},
          textColor={127,0,0},
          textString="Q_flow"),
        Line(points={{-68,20},{68,20}}, color={191,0,0}),
        Line(points={{-68,-20},{68,-20}}, color={191,0,0}),
        Line(points={{-56,80},{-56,-80}}, color={0,127,255}),
        Line(points={{-16,80},{-16,-80}},
                                      color={0,127,255}),
        Line(points={{18,80},{18,-80}}, color={0,127,255}),
        Line(points={{54,80},{54,-80}}, color={0,127,255}),
        Line(points={{-56,-80},{-66,-60}}, color={0,127,255}),
        Line(points={{-56,-80},{-46,-60}}, color={0,127,255}),
        Line(points={{-16,-80},{-26,-60}},
                                        color={0,127,255}),
        Line(points={{-16,-80},{-6,-60}},
                                        color={0,127,255}),
        Line(points={{18,-80},{8,-60}},  color={0,127,255}),
        Line(points={{18,-80},{28,-60}}, color={0,127,255}),
        Line(points={{54,-80},{44,-60}}, color={0,127,255}),
        Line(points={{54,-80},{64,-60}}, color={0,127,255}),
        Line(points={{48,-30},{68,-20}}, color={191,0,0}),
        Line(points={{48,-10},{68,-20}}, color={191,0,0}),
        Line(points={{48,10},{68,20}}, color={191,0,0}),
        Line(points={{48,30},{68,20}}, color={191,0,0}),
        Rectangle(
          extent={{76,80},{90,-78}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-100,86},{-86,76}},
          textColor={0,0,127},
          textString="u")}),
    Documentation(info="<html>
Model for convective heat tranfer in a single layer of window gas.
Currently, the model only implements equations for vertical windows
and for horizontal windows.
The computation is according to TARCOG 2006,
except that this implementation computes the convection coefficient
as a function that is differentiable in the temperatures.
<p>
To use this model, set the parameter <code>til</code>
to a value defined in
<a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>.
</p>
<br/>

<p>
If the parameter <code>linearize</code> is set to <code>true</code>,
then all equations are linearized.
</p>
<h4>References</h4>

TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Added assertion as the gas layer is now by
default assigned a dummy layer with negative thickness.
This has been done to avoid a translation error
in OpenModelica.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Removed duplicate <code>initial equation</code> section.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GasConvection;
