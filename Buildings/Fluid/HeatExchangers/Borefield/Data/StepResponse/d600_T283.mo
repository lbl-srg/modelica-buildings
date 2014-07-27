within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.StepResponse;
record d600_T283
  "Step response with discrete time step of 10 min and initial ground temperature of 283.15 K"
  extends Records.StepResponse(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.StepResponse.d600_T283",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/StepResponse/d600_T283.mo"),
    tStep=600,
    q_ste=21.99,
    m_flow=0.3,
    T_ini=283.15);
end d600_T283;
