within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
model PressureDropCircularPipe
  "Major and minor pressure loss of a circular vertical GHE pipe"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean computePressureDrop = true
    "Set to true to compute Darcy-Weisbach pressure drop";
  parameter Modelica.Units.SI.Length length
    "Pipe length";
  parameter Modelica.Units.SI.Radius rTub
    "Outer tube radius";
  parameter Modelica.Units.SI.Length eTub
    "Tube wall thickness";
  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  parameter Modelica.Units.SI.Density rhoMed
    "Fluid density";
  parameter Modelica.Units.SI.DynamicViscosity muMed
    "Fluid dynamic viscosity";
  parameter Integer nUBend(min=0) = 1
    "Number of U-bends represented by this pressure-drop component"
    annotation (Dialog(enable=computePressureDrop));
  parameter Real KUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend"
    annotation (Dialog(enable=computePressureDrop));

protected
  final parameter Real KMinor(unit="1") = nUBend*KUBend
    "Total minor-loss coefficient";

equation
  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  dp =
    if computePressureDrop then
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe(
        length=length,
        rTub=rTub,
        eTub=eTub,
        roughness=roughness,
        rhoMed=rhoMed,
        muMed=muMed,
        m_flow=m_flow,
        KMinor=KMinor)
    else
      0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-100,0},{-60,0}},
          color={0,127,255},
          thickness=1),
        Line(
          points={{60,0},{100,0}},
          color={0,127,255},
          thickness=1),
        Line(
          points={{-60,0},{-45,25},{-30,-25},{-15,25},{0,-25},{15,25},{30,-25},{45,25},{60,0}},
          color={0,127,255},
          thickness=1)}),
    Documentation(info="<html>
<p>
This model computes the pressure loss of a circular vertical ground heat
exchanger pipe.
</p>

<p>
If <code>computePressureDrop=true</code>, the pressure drop is computed from the
instantaneous mass flow rate using
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>.
The calculation includes the major Darcy-Weisbach pipe-friction loss and the
U-bend minor loss.
</p>

<p>
The total U-bend minor-loss coefficient passed to the pressure-loss function is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K<sub>minor</sub> = n<sub>UBend</sub> K<sub>UBend</sub>.
</p>
<p>
For a single U-tube, use <code>nUBend=1</code>. For a double U-tube, use
<code>nUBend=2</code>.
</p>

<p>
If <code>computePressureDrop=false</code>, this component imposes zero pressure
drop and acts as a hydraulic pass-through. In that case, U-bend minor losses are
not included.
</p>

<p>
The equations used for the major and minor pressure-loss calculations are
documented in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2026, by Lone Meertens:<br/>
First implementation for Darcy-Weisbach pressure-drop calculation in vertical
GHE pipes.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));

end PressureDropCircularPipe;
