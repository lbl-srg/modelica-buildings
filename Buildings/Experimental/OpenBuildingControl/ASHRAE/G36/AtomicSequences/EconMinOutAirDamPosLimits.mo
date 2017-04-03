within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconMinOutAirDamPosLimits
  "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."

  CDL.Interfaces.RealInput VOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput VOutMin
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
                                               //fixmi add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition."
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  CDL.Continuous.LimPID OutAirController(
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,

    yMax=1,
    yMin=0)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));

  CDL.Continuous.Constant RetDamPhyPosMax1(
                                          k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper"
    annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
equation
  connect(VOutMin, OutAirController.u_s)
    annotation (Line(points={{-120,80},{-72,80}}, color={0,0,127}));
  connect(VOut, OutAirController.u_m) annotation (Line(points={{-120,40},{-82,
          40},{-82,40},{-82,40},{-82,64},{-60,64},{-60,68}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -160},{100,100}}),                                  graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),                                   Line(
          points={{0,60},{-52,-40},{54,-40},{0,60}},
          color={28,108,200},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,
            100}})));
end EconMinOutAirDamPosLimits;
