within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconMinOutAirDamPosLimits

  CDL.Interfaces.RealInput VOut
    "Measured outdoor airflow rate. Sensor output. Location: at the outdoor air intake after the economizer damper."
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput VOutMin
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
                                               //fixmi add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition."
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),                                   Line(
          points={{0,60},{-52,-40},{54,-40},{0,60}},
          color={28,108,200},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EconMinOutAirDamPosLimits;
