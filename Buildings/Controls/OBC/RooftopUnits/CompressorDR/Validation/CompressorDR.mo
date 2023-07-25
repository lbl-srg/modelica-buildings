within Buildings.Controls.OBC.RooftopUnits.CompressorDR.Validation;
model CompressorDR "Validation model for CompressorDR"
  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDR
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
annotation (
    experiment(StopTime=1800, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/CompressorDR/Validation/CompressorDR.mos"
        "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Fluid.RooftopUnits.Controls.AuxiliaryCoil\">
    Buildings.Fluid.RooftopUnits.Controls.AuxiliaryCoil</a>. The model comprises the controllers
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
end CompressorDR;
