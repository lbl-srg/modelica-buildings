within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.IO.Hardware;
block ComissioningConstants
  "Outputs constant values set at comissioning"

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1")= 1
    "Physical or at the comissioning fixed minimum position of the return damper";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1")=0
    "Physical or at the comissioning fixed maximum open position of the return  air damper.";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1")=1
    "Physical or at the comissioning fixed minimum opening of the outdoor  air damper.";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1")=0
    "Physical or at the comissioning fixed maximum opening of the outdoor  air damper.";

  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the outdoor damper. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum open position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{76,66},{-54,-58}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Rectangle(
          extent={{56,60},{88,-66}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ComissioningConstants;
