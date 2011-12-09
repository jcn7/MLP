/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2000-2002 
%
% Michail G. Lagoudakis (mgl@cs.duke.edu)
% Ronald Parr (parr@cs.duke.edu)
%
% Department of Computer Science
% Box 90129
% Duke University
% Durham, NC 27708
% 
%
%
% C implementation of the equation of the bicycle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*/


#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/types.h>
#include <limits.h>
#include <signal.h>
/*#include <sys/times.h>
#include <sys/time.h> */
#include <errno.h>


double calc_dist_to_goal(double xf, double xb, double yf, double yb);
double calc_angle_to_goal(double xf, double xb, double yf, double yb);
double orig_calc_angle_to_goal(double xf, double xb, double yf, double yb);


#define sqr(x)       ((x)*(x))

#define dt           0.01   
#define v            (10.0/3.6)  /* 10 km/h in m/s */
#define g            9.82
#define dCM          0.3
#define c            0.66
#define h            0.94
#define Mc           15.0
#define Md           1.7
#define Mp           60.0
#define M            (Mc + Mp)
#define R            0.34          /* tyre radius */
#define sigma_dot    ( ((double) v) /R)
#define I_bike       ((13.0/3)*Mc*h*h + Mp*(h+dCM)*(h+dCM))
#define I_dc         (Md*R*R)  
#define I_dv         ((3.0/2)*Md*R*R)  
#define I_dl         ((1.0/2)*Md*R*R)  
#define l            1.11     /* distance between the point where
                         the front and back tyre touch the ground */

#define mypi         (acos(-1))

/* position of goal */
const double x_goal=1000.0, y_goal=0.0, radius_goal=10.0;



double sign(double x)
{
  if (x==0.0)
    return 0.0;
  else if (x>0.0)
    return +1.0;
  else 
    return -1.0;
}

/*
double max(double x, double y)
{
  if (x>=y)
    return x;
  else 
    return y;
}*/


void bicycle(double *nextstate, double *reward, double *endsim, 
	     double *istate,  double *action, int to_do, double *maxnoise)
{
  static double omega, omega_dot, omega_d_dot,
    theta, theta_dot, theta_d_dot, 
    xf, yf, xb, yb;                   /* tyre position */
  double T, d;
  static double rCM, rf, rb;
  static double phi,
    psi,            /* bike's angle to the y-axis */
    psi_goal;       /* Angle to the goal */
  double temp;
  static double lastdtg, dtg;
  double noise;
  double old_omega;
  double real_psi;
  double tempcos;
  double default_angle = mypi/2.0;
  
  printf("in bike code. ");
  if (to_do<=1) {

    if (to_do==0) {
      theta = theta_dot = theta_d_dot = 0.0;
      omega = omega_dot = omega_d_dot = 0.0;
      xb = 0.0; 
      yb = 0.0;
      xf = l * cos(default_angle); 
      yf = l * sin(default_angle);
    }
    else {
      theta       = istate[0];
      theta_dot   = istate[1];
      theta_d_dot = 0.0;
      omega       = istate[2];
      omega_dot   = istate[3];
      omega_d_dot = istate[4];
      xb          = istate[7]; 
      yb          = istate[8];
      xf = xb + l * cos(istate[5]);
      yf = yb + l * sin(istate[5]); 

    }
    
    temp = yf - yb;
    if ((xf == xb) && (temp < 0)) psi = mypi;
    else {
      if (temp > 0) psi = atan((xb-xf)/temp);
      else psi = sign(xb-xf)*(mypi/2) - atan(temp/(xb-xf));
    }


    psi_goal = orig_calc_angle_to_goal(xf, xb, yf, yb);
    lastdtg = calc_dist_to_goal(xf, xb, yf, yb);

    nextstate[0] = theta; 
    nextstate[1] = theta_dot;
    nextstate[2] = omega;
    nextstate[3] = omega_dot;
    nextstate[4] = omega_d_dot;
    nextstate[5] = psi_goal;
    nextstate[6] = lastdtg;
    nextstate[7] = xb;
    nextstate[8] = yb;
    nextstate[9] = xf;
    nextstate[10] = yf;

    *reward = 0.0;
    *endsim = 0.0;
    printf("in bike code2. ");
    return;
  }
  
  T = action[0];
  d = action[1];

  /* Noise in displacement*/
/* noise = ( (double) (random() % ((long) pow(2,30)) ) ) / pow(2,30); */
/*    noise = ( (double) (rand() % ((long) pow(2,30)) ) ) / pow(2,30);  */ 
  noise = rand()/((double)RAND_MAX + 1); 

  noise = noise*2 - 1;
  d = d + *maxnoise * noise; /* Max noise is 2 cm */

  old_omega = omega;

  if (theta == 0) {
    rCM = rf = rb = 9999999; /* just a large number */
  } else {
    rCM = sqrt(pow(l-c,2) + l*l/(pow(tan(theta),2)));
    rf = l / fabs(sin(theta));
    rb = l / fabs(tan(theta));
  } /* rCM, rf and rb are always positiv */
  
  /* Main physics eq. in the bicycle model coming here: */
  phi = omega + atan(d/h);
  omega_d_dot = ( h*M*g*sin(phi) 
                  - cos(phi)*(I_dc*sigma_dot*theta_dot 
		              + sign(theta)*v*v*(Md*R*(1.0/rf + 1.0/rb) 
				     +  M*h/rCM) )
                ) / I_bike;
  theta_d_dot =  (T - I_dv*omega_dot*sigma_dot) /  I_dl;
  
  /*--- Eulers method ---*/
  omega_dot += omega_d_dot * dt;
  omega     += omega_dot   * dt;
  theta_dot += theta_d_dot * dt;
  theta     += theta_dot   * dt;
  
  if (fabs(theta) > 1.3963) { /* handlebars cannot turn more than 
				 80 degrees */
    theta = sign(theta) * 1.3963;
  }
  
  /* New position of front tyre */
  temp = v*dt/(2*rf);                             
  if (temp > 1) temp = sign(psi + theta) * mypi/2;
  else temp = sign(psi + theta) * asin(temp); 
  xf += v * dt * (-sin(psi + theta + temp));
  yf += v * dt * cos(psi + theta + temp);
  
  /* New position of back tyre */
  temp = v*dt/(2*rb);               
  if (temp > 1) temp = sign(psi) * mypi/2;
  else temp = sign(psi) * asin(temp); 
  xb += v * dt * (-sin(psi + temp));
  yb += v * dt * (cos(psi + temp));
  
  /* Round off errors accumulate so the length of the bike changes over many
     iterations. The following take care of that: */
  temp = sqrt((xf-xb)*(xf-xb)+(yf-yb)*(yf-yb));

      /*Correct back wheel*/
  if (fabs(temp - l) > 0.001) {
    xb += (xb-xf)*(l-temp)/temp;
    yb += (yb-yf)*(l-temp)/temp;
    }

  /*
    // or, Correct front wheel
  temp = sqrt((xf-xb)*(xf-xb)+(yf-yb)*(yf-yb));
  if (fabs(temp - l) > 0.001) {
    xf += (xf-xb)*(l-temp)/temp;
    yf += (yf-yb)*(l-temp)/temp;
  }
  */

  temp = yf - yb;
  if ((xf == xb) && (temp < 0)) psi = mypi;
  else {
    if (temp > 0) psi = atan((xb-xf)/temp);
    else psi = sign(xb-xf)*(mypi/2) - atan(temp/(xb-xf));
  }
  
  psi_goal = orig_calc_angle_to_goal(xf, xb, yf, yb);
  dtg = calc_dist_to_goal(xf, xb, yf, yb);
  
  nextstate[0] = theta; 
  nextstate[1] = theta_dot;
  nextstate[2] = omega;
  nextstate[3] = omega_dot;
  nextstate[4] = omega_d_dot;
  nextstate[5] = psi_goal;
  nextstate[6] = dtg;
  nextstate[7] = xb;
  nextstate[8] = yb;
  nextstate[9] = xf;
  nextstate[10] = yf;

  /*-- Calculation of the reward  signal --*/

 /* *reward = mypi/2 - sqr(omega*15/mypi); */ /* ME /*                                             
  
    *reward = (fabs(old_omega) - fabs(omega))*15/mypi;
  //  *reward = ((old_omega)*(old_omega) - (omega * omega))*15/mypi;
  //  *reward = exp(-fabs(old_omega*15/mypi)) - exp(-fabs(omega*15/mypi));*/

   *reward = sqr(old_omega*15/mypi) - sqr(omega*15/mypi);  /*PARR*/
   
   if (fabs(omega) > (mypi/15)) { /* the bike has fallen over */
    *endsim =  1.0;
    *reward = -1.0;   //jleahey
    /* a good place to print some info to a file or the screen */  
  } else {
    *endsim = 0.0;
    
   /* *reward = 0.1; */ /* ME added to make goal balancing*/
    
    /* 0.0008 turns away from goal */
    // 0.008 crashes
    // 0.08 worked well before
    // 0.01 with discount 0.81 works*/
    
    *reward += (lastdtg - dtg) * .01;  /*PARR*/

  /*   *reward = (4 - (psi_goal * psi_goal)) * .00004; */ /*Jette*/
    
//   *reward += (sign(lastdtg-dtg)*sqr(lastdtg - dtg)) * 0.35;
   
    lastdtg = dtg; 
  }
  
  /*if(dtg <= 10.0)
  {
    *reward=100;
    puts("Goal reached!");
  }
   ME */

  return;
  
}



double calc_dist_to_goal(double xf, double xb, double yf, double yb)
{
  double temp;

  /* Distance is computed from the front wheel, works best for shaping */

  temp = sqrt( max(0, sqr(x_goal-xf)+sqr(y_goal-yf)-sqr(radius_goal) ) ); 
  return(temp);
}


/*
// Weird angle from the back wheel
double calc_angle_to_goal(double xf, double xb, double yf, double yb)
{
  double temp, scalar, perpx, perpy, s, cosine, bikelen;

  temp = (xf-xb)*(x_goal-xb) + (yf - yb)*(y_goal-yf); 
  bikelen = sqrt(sqr(xf - xb) + sqr(yf-yb));
  scalar =  bikelen * sqrt(sqr(x_goal-xb)+sqr(y_goal-yb));

  perpx = yb - y_goal;
  perpy = x_goal - xb;

  s = sign((xf-xb)*perpx + (yf-yb)*perpy);

  cosine = temp/scalar;

  if (cosine > 1.0)
    cosine = 1.0;

  if (cosine < -1.0)
    cosine = -1.0;

  if (s > 0)
    return 1.0-cosine;
  else
    return -1.0+cosine;
}
*/

/*
// Angle from the front wheel
double calc_angle_to_goal(double xf, double xb, double yf, double yb)
{
  double temp, scalar, perpx, perpy, s, cosine, bikelen;

  temp = (xf-xb)*(x_goal-xf) + (yf-yb)*(y_goal-yf); 
  bikelen = sqrt( sqr(xf-xb) + sqr(yf-yb) );
  scalar =  bikelen * sqrt( sqr(x_goal-xf) + sqr(y_goal-yf) );

  perpx = yf - y_goal;
  perpy = x_goal - xf;

  s = sign( (xf-xb)*perpx + (yf-yb)*perpy );

  cosine = temp/scalar;

  if (cosine > 1.0)
    cosine = 1.0;

  if (cosine < -1.0)
    cosine = -1.0;

  if (s > 0)
    return acos(cosine);
  else
    return -acos(cosine);
}
*/

/* Angle from the back wheel */
double calc_angle_to_goal(double xf, double xb, double yf, double yb)
{
  double temp, scalar, perpx, perpy, s, cosine, bikelen;

  temp = (xf-xb)*(x_goal-xb) + (yf-yb)*(y_goal-yb); 
  bikelen = sqrt( sqr(xf-xb) + sqr(yf-yb) );
  scalar =  bikelen * sqrt( sqr(x_goal-xb)+sqr(y_goal-yb) );

  perpx = yb - y_goal;
  perpy = x_goal - xb;

  s = sign( (xf-xb)*perpx + (yf-yb)*perpy );

  cosine = temp/scalar;

  if (cosine > 1.0)
    cosine = 1.0;

  if (cosine < -1.0)
    cosine = -1.0;

  if (s > 0)
    return acos(cosine);
  else
    return -acos(cosine);
}



/* Original Angle Function */
double orig_calc_angle_to_goal(double xf, double xb, double yf, double yb) 
  { 
    double temp, scalar, tvaer; 

    temp = (xf-xb)*(x_goal-xf) + (yf-yb)*(y_goal-yf);  
    scalar =  temp / (l * sqrt(sqr(x_goal-xf)+sqr(y_goal-yf))); 
    tvaer = (-yf+yb)*(x_goal-xf) + (xf-xb)*(y_goal-yf);  

    if (tvaer <= 0) temp = scalar - 1; 
    else temp = fabs(scalar - 1); 

    /*
     These angles are neither in degrees nor radians, but something 
       strange invented in order to save CPU-time. The measure is arranged the 
       same way as radians, but with a slightly different negative factor.  

       Say, the goal is to the east. 
       If the agent rides to the east then  temp = 0 
       - " -          - " -   north              = -1 
       - " -                  west               = -2 or 2 
       - " -                  south              =  1   
       
    */

    return(temp); 
  } 


#include "mex.h"

/* Input Arguments */

#define	S_IN	prhs[0]
#define	A_IN	prhs[1]
#define M_IN    prhs[2]

/* Output Arguments */

#define	NS_OUT	plhs[0]
#define	RE_OUT	plhs[1]
#define	ES_OUT	plhs[2]


void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )
     
{ 

  double *state;
  double *reward;
  double *endsim;
  double *istate;
  double *action;
  int to_do;
  double *maxnoise;
 
  /* Check for proper number of arguments. */
  if (nrhs>3) {
    mexErrMsgTxt("Too many inputs!.");
  } 
  else if (nlhs>3) {
    mexErrMsgTxt("Too many output arguments!");
  }
  
  /* Create a matrix for the return argument */ 
  NS_OUT = mxCreateDoubleMatrix(1, 11, mxREAL); 
  RE_OUT = mxCreateDoubleMatrix(1, 1, mxREAL); 
  ES_OUT = mxCreateDoubleMatrix(1, 1, mxREAL); 
  
  /* Assign pointers to the various parameters */ 
  state  = mxGetPr(NS_OUT);
  reward = mxGetPr(RE_OUT);
  endsim = mxGetPr(ES_OUT);

  if (nrhs==0)
    to_do = 0;
  else if (nrhs==1) {
    istate = mxGetPr(S_IN); 
    to_do = 1;
  }
  else {
    istate = mxGetPr(S_IN); 
    action = mxGetPr(A_IN);
    to_do = 2;
    maxnoise = mxGetPr(M_IN);
  }
  
    /* Do the actual computations in a subroutine */
  bicycle(state, reward, endsim, istate, action, to_do, maxnoise);    

  return;
    
}


