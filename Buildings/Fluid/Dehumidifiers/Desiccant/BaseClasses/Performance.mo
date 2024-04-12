within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
model Performance
  "Model calculates the outlet condition of the process air through a desiccant dehumidifier"
    extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Velocity vPro_nominal
    "Nominal velocity of the process air";
  parameter Modelica.Units.SI.VolumeFlowRate VPro_flow_nominal
    "Nominal volumetric flow rate of the process air";
  parameter Modelica.Units.SI.Velocity vReg_nominal
    "Nominal velocity of the regeneration air";
  parameter Modelica.Units.SI.VolumeFlowRate VReg_flow_nominal
    "Nominal volumetric flow rate of the regeneration air";
  parameter Modelica.Units.SI.HeatFlowRate QReg_flow_nominal
    "Nominal regeneration heating capacity";
  parameter Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));
  final parameter Real a[:] = {0.48,1.7658,-2.1537,0.9091}
    "Coefficients for calculating the sensible heat exchange effectiveness";
  final parameter Real b[:] = {-0.8045,5.6984,-6.6667,2.7778}
    "Coefficients for calculating the latent heat exchange effectiveness";
  final parameter Real uSpe_min = 0.3
    "Minimum allowable wheel speed ratio";
  Modelica.Blocks.Interfaces.BooleanInput onDeh
    "Set to true to enable the dehumidification process" annotation (Placement(
        transformation(extent={{-124,68},{-100,92}}), iconTransformation(extent=
           {{-120,72},{-100,92}})));
  Modelica.Blocks.Interfaces.RealInput TProEnt(
    final unit="K")
    "Temperature of the process air entering the dehumidifier"
     annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
     iconTransformation(extent={{-120,32},{-100,52}})));
  Modelica.Blocks.Interfaces.RealInput X_w_ProEnt(
     final unit="1")
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(
    extent={{-124,-54},{-100,-30}}),iconTransformation(extent={{-120,-50},
    {-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput VPro_flow(
     final unit="m3/s")
     "Volumetric  flow rate of the process air"
     annotation (Placement(transformation(
          extent={{-124,-92},{-100,-68}}),
          iconTransformation(extent={{-120,-92},{-100,-72}})));
  Modelica.Blocks.Interfaces.RealInput mPro_flow(
    final unit="kg/s") "Mass flow rate of the process air"
                                        annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={0,-112}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealInput TRegEnt(
    final unit="K")
    "Temperature of the regeneration air entering the dehumidifier" annotation (
     Placement(transformation(extent={{-124,-14},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    final min=0.3,
    final max=1)
    "Wheel speed ratio" annotation (Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=90,
        origin={-80,112}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-82,110})));
  Modelica.Blocks.Interfaces.RealOutput TProLea(
    final unit="K")
    "Temperature of the process air leaving the dehumidifier" annotation (
      Placement(transformation(extent={{100,70},{120,90}}), iconTransformation(
          extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput X_w_ProLea(
    final unit="1")
    "Humidity ratio of the process air leaving the dehumidifier"
     annotation (Placement(transformation(extent={{100,30},{120,50}}),
     iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput VReg_flow(
    final unit="m3/s")
    "Volumetric flow rate of the regeneration air" annotation (Placement(transformation(
          extent={{100,-50},{120,-30}}), iconTransformation(extent={{100,-50},{120,
            -30}})));
  Modelica.Blocks.Interfaces.RealOutput yQReg(
    final unit="1")
    "Regeneration heating output ratio" annotation (Placement(transformation(
          extent={{100,-90},{120,-70}}), iconTransformation(extent={{100,-90},{120,
            -70}})));
protected
  Real CpReg(final unit="J/kg")
    "Specific regeneration energy";
  Real etaSen(final unit="1")
    "Sensible heat exchange effectiveness";
  Real etaLat(final unit="1")
    "Latent heat exchange effectiveness";

equation
  if onDeh then
    assert(uSpe >= uSpe_min,
     "In " + getInstanceName() + ": the wheel speed ratio should not
     be lower than 0.3.",
     level=AssertionLevel.error);
    etaSen=Buildings.Utilities.Math.Functions.polynomial(a=a, x=uSpe);
    etaLat=Buildings.Utilities.Math.Functions.polynomial(a=b, x=uSpe);
    // Check the inlet condition of the process inlet condition.
    assert(TProEnt <= per.TProEnt_max and TProEnt >= per.TProEnt_min,
    "In " + getInstanceName() + ": temperature of the process air entering the dehumidifier is beyond 
    the range that is defined in the performance curve.",
    level=AssertionLevel.error);
     assert(X_w_ProEnt <= per.X_w_ProEnt_max and X_w_ProEnt >= per.X_w_ProEnt_min,
    "In " + getInstanceName() + ": humidity ratio of the process air entering the dehumidifier is beyond 
    the range that is defined in the performance curve.",
    level=AssertionLevel.error);
    VReg_flow =
      Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
      TProEnt=TProEnt,
      X_w_ProEnt=X_w_ProEnt,
      vPro=VPro_flow/VPro_flow_nominal*vPro_nominal,
      a=per.coevReg)/vReg_nominal*VReg_flow_nominal*uSpe;
     assert(VReg_flow <= VReg_flow_nominal,
     "In " + getInstanceName() + ": regeneration flow rate is not sufficient.",
     level=AssertionLevel.error);
     TProLea = TProEnt + (Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
        TProEnt = TProEnt,
        X_w_ProEnt = X_w_ProEnt,
        vPro = VPro_flow/VPro_flow_nominal*vPro_nominal,
        a = per.coeTProLea)+ 273.15 - TProEnt)*etaSen;
     X_w_ProLea = X_w_ProEnt-(X_w_ProEnt-(Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
        TProEnt = TProEnt,
        X_w_ProEnt = X_w_ProEnt,
        vPro = VPro_flow/VPro_flow_nominal*vPro_nominal,
        a = per.coeX_w_ProLea)))*etaLat;
     assert(X_w_ProLea > 0,
     "In " + getInstanceName() + ": humidity ratio of the process air leaving 
     the dehumidifier becomes negative.",
     level=AssertionLevel.error);
     CpReg = Buildings.Utilities.Math.Functions.smoothMax(
        x1 = Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
                TProEnt = TProEnt,
                X_w_ProEnt = X_w_ProEnt,
                vPro = VPro_flow/VPro_flow_nominal*vPro_nominal,
                a = per.coeQReg_flow)*uSpe,
        x2 = 0,
        deltaX = 0.01);
      yQReg = CpReg*(X_w_ProEnt - X_w_ProLea)*mPro_flow*(per.TRegEnt_nominal -
      TRegEnt)/(per.TRegEnt_nominal - TProEnt)/QReg_flow_nominal;
    assert(yQReg <= 1,
     "In " + getInstanceName() + ": heating power is not sufficient for regeneration.",
     level=AssertionLevel.error);
  else
    //No dehumidification occurs.
    TProLea = TProEnt;
    X_w_ProLea = X_w_ProEnt;
    VReg_flow = 0;
    CpReg = 0;
    yQReg = 0;
    etaSen = 0;
    etaLat = 0;
  end if;
  annotation (
  defaultComponentName="dehPer",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the outlet condition of the process air of a desiccant dehumidifier based on
the inlet condition of the process air.
Specifically, this calculation is configured as follows.
</p>
<ul>
 <li>
 If the dehumidification signal <code>onDeh=true</code>,
 <ul>
  <li>
  The inlet condition, in terms of temperature and humidity ratio, is compared
  to the corresponding limits in the performance curves of the desiccant dehumidifier.
  Those performance curves are defined in <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic\"> 
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic</a>.
  <ul>
     <li>
     If the inlet condition is beyond the limits, the calculation is terminated and an error is generated.
     </li>
  </ul>
  </li>
  <li>
  The sensible and latent heat exchange effectiveness is calculated by 
  <p align=\"center\" style=\"font-style:italic;\">
   etaSen = (a<sub>1</sub> + a<sub>2</sub> uSpe + a<sub>3</sub> uSpe<sup>2</sup> + ...),
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
   etaLat = (b<sub>1</sub> + b<sub>2</sub> uSpe + b<sub>3</sub> uSpe<sup>2</sup> + ...),
  </p>
  where the <code>a[:]</code> and <code>b[:]</code> are the coefficients obtained based on 
  ASHRAE Handbook—HVAC Systems &amp; Equipment (Figure 7, Chapter 26),
  <code>uSpe</code> is the wheel speed ratio.
  </li>
  <li>
  The velocity of the process air is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
   vPro = VPro_flow/VPro_flow_nominal*vPro_nominal
  </p> 
  where <code>VPro_flow</code> is the volumetric flow rate of the process air,
  <code>VPro_flow_nominal</code> is the nominal volumetric flow rate of the process air,
  <code>vPro_nominal</code> is the nominal velocity of the process air.
  <br>
  Then, the volumetric flow rate of the regeneration air is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
   VReg_flow = f(TProEnt,X_w_ProEnt,vPro,coevReg)/vReg_nominal*VReg_flow_nominal*uSpe
  </p>
  where <code>f(.)</code> is defined in <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve\">
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve</a>,
  <code>coevReg</code> are coefficients, as defined in <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic\">
  Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic</a>,
  <code>TProEnt</code> and <code>X_w_ProEnt</code> are the temperature and the humidity ratio of the process air entering the dehumidifier,
  respectively.
  <ul>
     <li>
     If <code>VReg_flow>VReg_flow_nominal</code>, the calculation is terminated and an error is generated.
     </li>
  </ul>
  </li>
  <li>
  The temperature of the process air leaving the dehumidifier, <code>TProLea</code> is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
    TProLea = TProEnt + (f(TProEnt,X_w_ProEnt,vPro,coeTProLea) + 273.15 - TProEnt)*etaSen,
  </p>
  where <code>coeTProLea</code> are coefficients.
  <br> 
  The humidity ratio of the process air leaving the dehumidifier, <code>X_w_ProLea</code>, is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
    X_w_ProLea = X_w_ProEnt - (X_w_ProEnt - f(TProEnt,X_w_ProEnt,vPro,coeX_w_ProLea))*etaLat,
  </p>
  where <code>coeX_w_ProLea</code> are coefficients.
  <ul>
     <li>
     If <code>X_w_ProLea</code> is less than 0,
     the calculation is terminated and an error is generated.
     </li>
  </ul>
  </li>
  <li>
  The specific heat of the regeneration, <code>CpReg</code> is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
    CpReg =max(0,f(TProEnt,X_w_ProEnt,vPro,coeCpReg)*uSpe),
  </p>
  where <code>coeCpReg</code> are coefficients.
  <br>
  After that, the regeneration heating output ratio, <code>yQReg</code>, is calculated by
  <p align=\"center\" style=\"font-style:italic;\">
   yQReg = CpReg*(X_w_ProEnt-X_w_ProLea)*mPro_flow*(TRegEnt_nominal - TRegEnt) / (TRegEnt_nominal - TProEnt)/
   QReg_flow_nominal,
  </p> 
  where <code>TRegEnt_nominal</code> and <code>TRegEnt</code> are the nominal temperature and the actual temperature
  of the regeneration air entering the dehumidifier.<code>QReg_flow_nominal</code> is the nominal regeneration 
  heating capacity.
  <ul>
     <li>
     If <code>yQReg</code> is larger than 1,
     the calculation is terminated and an error is generated.
     </li>
  </ul>
  </li>
 </ul>
 </li>

 <li>
 Otherwise, 
 <ul>
  <li>
  The outlet condition of the process air is the same as the inlet condition of the process air.
  </li>
  <li>
  <code>VReg_flow</code> and <code>yQReg</code> are set to be 0.
  </li>
 </ul>
 </li>

</ul>
<h4>References</h4>
<ul>
<li>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.1.0/EngineeringReference.pdf\">
EnergyPlus v22.1.0 Engineering Reference</a>
</li>
<li>
<a href=\"https://www.ashrae.org/file%20library/technical%20resources/covid-19/i-p_s20_ch26.pdf\">
ASHRAE Handbook—HVAC Systems &amp; Equipment Chapter 26</a>
</li>
</ul>
 
</html>", revisions="<html>
<ul>
<li>April 10, 2024, by Sen Huang:<br/>Added wheel speed ratio as an input. </li>
</ul>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>First implementation. </li>
</ul>
</html>"));
end Performance;
