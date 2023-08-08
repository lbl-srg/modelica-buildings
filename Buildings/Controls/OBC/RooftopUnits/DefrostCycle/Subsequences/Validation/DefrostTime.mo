within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.Validation;
model DefrostTime "Validation model for defrost time"
  CDL.Continuous.Sources.Constant                    phi(k=0.9)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  CDL.Continuous.Sources.Ramp     TOut(
    height=-5,
    duration=100,
    offset=273.15 - 10)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.DefrostTime
    DefTim annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(DefTim.TOut, TOut.y) annotation (Line(points={{18,6},{0,6},{0,32},{-18,
          32}},      color={0,0,127}));
  connect(DefTim.phi, phi.y) annotation (Line(points={{18,-6},{0,-6},{0,-30},{-18,
          -30}},      color={0,0,127}));
annotation (
    experiment(StopTime=100, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DefrostCycle/Validation/DefrostCycle.mos"
        "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.Validation\">
    Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.Validation</a>. The model comprises the controllers
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
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end DefrostTime;
