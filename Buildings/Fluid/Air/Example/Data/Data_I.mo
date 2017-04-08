within Buildings.Fluid.Air.Example.Data;
record Data_I
  extends Buildings.Fluid.Air.Data.Generic.AirHandingUnit(
  nomVal(dpCoil1_nominal=3000, dpCoil2_nominal=200,Q_flow_nominal=60000,
        UA_nominal=6864,
        mWat_flow_nominal=0.001,
        QHeater_nominal=1000,
        dpValve_nominal=6000),
  perCur( pressure(V_flow=2.58*{0,0.5,1}, dp=300*{1.2,1.12,1})));


end Data_I;
