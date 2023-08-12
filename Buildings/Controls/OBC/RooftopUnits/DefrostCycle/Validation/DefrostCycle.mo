within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Validation;
model DefrostCycle "Validation model for defrost cycle"
  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.DefrostCycle DefCyc
    "Controller for defrost cycle"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Continuous.Sources.Constant                    phi(k=0.9)
    "Constant relative humidity"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Continuous.Sources.Constant                        TDryBul(k=273.15 - 15)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  CDL.Continuous.Sources.Constant TFroSen(k=273.15 - 15)
    "Constant frost sensor temperature"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
equation
  connect(TDryBul.y, DefCyc.TOut) annotation (Line(points={{-18,-20},{0,-20},{0,
          -64},{18,-64}},
                    color={0,0,127}));
  connect(phi.y, DefCyc.phi)
    annotation (Line(points={{-18,-70},{18,-70}},
                                                color={0,0,127}));
  connect(TFroSen.y, DefCyc.TFroSen) annotation (Line(points={{-18,-120},{12,
          -120},{12,-76},{18,-76}},
                            color={0,0,127}));
annotation (
    experiment(StopTime=1800, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DefrostCycle/Validation/DefrostCycle.mos"
        "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Validation\">
    Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Validation</a>. The model comprises the controllers
    <code>conAuxCoi</code> and <code>conAuxCoi1</code>, which receives input signals 
    including outdoor air temperatures <code>TOut</code> and <code>TOut1</code> and heating 
    coil valve position signals <code>heaSetPoi</code> and <code>heaSetPoi1</code>, respectively.
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    July 3, 2023, by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-140},{100,140}})));
end DefrostCycle;
