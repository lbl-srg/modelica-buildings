within Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.Validation;
model AuxiliaryCoil "Validation model for auxiliary coil controller"

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi(
    TLocOut=273.15 - 12.2,
    dTHys=273.1,
    k1=1,
    k2=10,
    uThrHeaCoi=0.9,
    dUHys=0.01) "Instance of controller for auxiliary heating coil"
    annotation (Placement(transformation(extent={{20,42},{40,62}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp HeaCoi(
    final height=1,
    final offset=0,
    final duration=1200)
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    k=273.15 - 15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi1(
    TLocOut=273.15 - 12.2,
    dTHys=273.1,
    k1=1,
    k2=10,
    uThrHeaCoi=0.9,
    dUHys=0.01) "Instance of controller for auxiliary heating coil"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    k=273.15 - 10)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp HeaCoi1(
    final height=1,
    final offset=0,
    final duration=1200)
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(conAuxCoi.uHeaCoi, HeaCoi.y) annotation (Line(points={{18,50},{0,50},
          {0,30},{-18,30}},     color={0,0,127}));
  connect(TOut.y, conAuxCoi.TOut) annotation (Line(points={{-18,80},{0,80},{0,
          54},{18,54}},
                      color={0,0,127}));
  connect(TOut1.y, conAuxCoi1.TOut) annotation (Line(points={{-18,-20},{0,-20},
          {0,-48},{18,-48}},color={0,0,127}));
  connect(HeaCoi1.y, conAuxCoi1.uHeaCoi) annotation (Line(points={{-18,-80},{0,-80},
          {0,-52},{18,-52}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/AuxiliaryCoil/Validation/AuxiliaryCoil.mos"
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
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When <code>TOut</code> drops to <i>-15</i>&deg;C, which is below the outdoor air lockout temperature 
    <code>TLocOut</code> (e.g., <i>-12.2</i>&deg;C), and <code>uHeaCoi</code> exceeds a threshold 
    <code>uThrHeaCoi</code> value of 0.9, the controller outputs <code>conAuxCoi.yAuxHea</code> from 0.9 to 1 
    depending on the value of <code>uHeaCoi</code>. Additionally, the controller outputs 0 
    when <code>uHeaCoi</code> falls below the threshold value of 0.9.
    </li>
    <li>
    When <code>TOut1</code> reaches <i>-10</i>&deg;C, which is above <code>TLocOut</code> of <i>-12.2</i>&deg;C, 
    and <code>uHeaCoi1</code> exceeds the threshold value of 0.9, the controller outputs <code>conAuxCoi1.yAuxHea</code> 
    based on the product of the P controller output <code>conAuxCoi1.conPHeaHig.y</code> and 
    the difference between <code>uHeaCoi1</code> and 0.9. Additionally, the controller outputs 0 
    when <code>uHeaCoi1</code> falls below the threshold value of 0.9.
    </li>
    </ul>
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
end AuxiliaryCoil;
