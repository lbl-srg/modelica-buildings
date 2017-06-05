within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.IO.Hardware;
block ComissioningConstants
  "Outputs constant values set at comissioning"

  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper. fixme: It should always be 0 (pp), should we define this as final? fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position. fixme: this maybe needs to be an input. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{62,66},{-68,-58}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Rectangle(
          extent={{42,60},{74,-66}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ComissioningConstants;
