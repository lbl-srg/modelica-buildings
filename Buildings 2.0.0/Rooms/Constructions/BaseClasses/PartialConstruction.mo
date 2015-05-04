within Buildings.Rooms.Constructions.BaseClasses;
partial model PartialConstruction
  "Partial model for exterior construction that has no window"

  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Modelica.SIunits.Area AOpa
    "Heat transfer area of opaque construction"
    annotation (Dialog(group="Opaque construction"));

  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Material properties of opaque construction"
    annotation(Dialog(group="Opaque construction"),
               choicesAllMatching=true, Placement(transformation(extent={{146,258},
            {166,278}})));

  parameter Modelica.SIunits.Angle til "Surface tilt";

  final parameter Boolean isFloor=til > 2.74889125 and til < 3.53428875
    "Flag, true if construction is a floor" annotation (Evaluate=true);
  final parameter Boolean isCeiling=til > -0.392699 and til < 0.392699
    "Flag, true if construction is a floor" annotation (Evaluate=true);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a opa_a
    "Heat port at surface a of opaque construction"
    annotation (Placement(transformation(extent={{-310,190},{-290,210}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b opa_b
    "Heat port at surface b of opaque construction"
    annotation (Placement(transformation(extent={{292,190},{312,210}})));

  final parameter Integer nLay(min=1, fixed=true) = size(layers.material, 1)
    "Number of layers";
  final parameter Integer nSta[nLay](each min=1)=
    {layers.material[i].nSta for i in 1:nLay} "Number of states"
                        annotation(Evaluate=true);
  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
        annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.SIunits.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.SIunits.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));

  HeatTransfer.Conduction.MultiLayer opa(
    final A=AOpa,
    final layers=layers,
    final steadyStateInitial=steadyStateInitial,
    final T_a_start=T_a_start,
    final T_b_start=T_b_start)
    "Model for heat transfer through opaque construction"
    annotation (Placement(transformation(extent={{-52,148},{52,252}})));

equation
  connect(opa.port_a, opa_a) annotation (Line(
      points={{-52,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(opa.port_b, opa_b) annotation (Line(
      points={{52,200},{302,200}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},
            {300,300}})), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}}), graphics={
        Rectangle(
          extent={{-290,202},{298,198}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,254},{-52,140}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{2,208},{4,208},{6,204},{8,198},{8,194},{6,188},{0,184},{-4,180},
              {-12,178},{-16,182},{-22,188},{-24,198},{-22,204},{-20,208},{-18,210},
              {-16,212},{-12,214},{-8,214},{-2,212},{2,208}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,254},{52,140}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-314,336},{286,302}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
This is the base class that is used to model opaque constructions in the room model.
</p>
<p>
The surface azimuth is defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialConstruction;
