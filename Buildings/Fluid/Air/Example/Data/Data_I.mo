within Buildings.Fluid.Air.Example.Data;
record Data_I
  extends Buildings.Fluid.Air.Data.Generic.AirHandlingUnit(
  nomVal(T_a1_nominal=6 + 273.15,
         T_b1_nominal=11 + 273.15,
         T_a2_nominal=26 + 273.15,
         T_b2_nominal=12 + 273.15,
         m1_flow_nominal=2.9,
         m2_flow_nominal=3.3,
        dpCoil1_nominal=3000,
        dpCoil2_nominal=200,
        mWat_flow_nominal=0.01,
        QHeater_nominal=10000,
        dpValve_nominal=6000),
  perCur( pressure(V_flow=nomVal.m2_flow_nominal*{0,0.5,1}, dp=300*{1.2,1.12,1})));
  annotation (Documentation(info="<html>
<p>
This record is created for the above examples.
</p>
</html>"));
end Data_I;
