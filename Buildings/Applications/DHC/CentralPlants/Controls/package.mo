within Buildings.Applications.DHC.CentralPlants;
package Controls "Control blocks for district cooling plant"
  extends Modelica.Icons.VariantsPackage;

  model ChillerBypassControl
    "Chilled water loop bypass valve control"
    parameter Modelica.SIunits.Temperature TSet
      "The lower temperatre limit of condenser water entering the chiller plant";
    Modelica.Blocks.Interfaces.RealInput T
      "Temperature of the condenser water leaving the cooling tower"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Sources.Constant ByPassTSet(k=TSet)
      annotation (Placement(transformation(extent={{0,40},{-20,60}})));

    Buildings.Controls.Continuous.LimPID conPID(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      k=1,
      Ti=60) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(conPID.y, y) annotation (Line(
        points={{11,0},{110,0}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(ByPassTSet.y, conPID.u_s) annotation (Line(
        points={{-21,50},{-40,50},{-40,0},{-12,0}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(T, conPID.u_m) annotation (Line(
        points={{-120,0},{-80,0},{-80,-40},{0,-40},{0,-12}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{-44,22},{44,-22}},
            lineColor={0,0,255},
            textString="BypassControl"),
          Text(
            extent={{-42,-108},{52,-150}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>
<ul>
<li>
April 14, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>PI controller is employed to avoid overcooling condenser water by adjusting the three way opening.</p>
</html>"));
  end ChillerBypassControl;
end Controls;
