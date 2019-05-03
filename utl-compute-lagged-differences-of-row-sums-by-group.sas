Compute lagged differences of row sums by group                                                                
                                                                                                               
github                                                                                                         
https://tinyurl.com/y47zr3nv                                                                                   
https://github.com/rogerjdeangelis/utl-compute-lagged-differences-of-row-sums-by-group                         
                                                                                                               
SAS Forum                                                                                                      
https://tinyurl.com/y5veke8l                                                                                   
https://communities.sas.com/t5/SAS-Enterprise-Guide/sum-and-take-the-difference/m-p/555800                     
                                                                                                               
*_                   _                                                                                         
(_)_ __  _ __  _   _| |_                                                                                       
| | '_ \| '_ \| | | | __|                                                                                      
| | | | | |_) | |_| | |_                                                                                       
|_|_| |_| .__/ \__,_|\__|                                                                                      
        |_|                                                                                                    
;                                                                                                              
                                                                                                               
* Note I aligned the input by highlighting                                                                     
  the input and typeing 'cuth' on the command line command macro on end;                                       
* you can put the entire macro with invocation on a function key;                                              
                                                                                                               
%macro cuth/cmd;                                                                                               
  %do i=1 %to 20;                                                                                              
    c '  ' ' ' all;                                                                                            
  %end;                                                                                                        
%mend cuth;                                                                                                    
                                                                                                               
data have;                                                                                                     
  input city $ month :date9. count ;                                                                           
  format month date9.;                                                                                         
cards4;                                                                                                        
NEV 01-Dec-2018 50                                                                                             
NEV 01-Dec-2018 40                                                                                             
REN 01-Dec-2018 20                                                                                             
REN 01-Dec-2018 80                                                                                             
NEV 01-jan-2019 15                                                                                             
NEV 01-jan-2019 15                                                                                             
REN 01-jan-2019 10                                                                                             
REN 01-jan-2019 10                                                                                             
;;;;                                                                                                           
run;quit;                                                                                                      
                                                                                                               
Up to 40 obs WORK.HAVE total obs=8                                                                             
                                                                                                               
Obs    CITY    MONTH    COUNT                                                                                  
                                                                                                               
 1     NEV     21519      50                                                                                   
 2     NEV     21519      40                                                                                   
 3     REN     21519      20                                                                                   
 4     REN     21519      80                                                                                   
 5     NEV     21550      15                                                                                   
 6     NEV     21550      15                                                                                   
 7     REN     21550      10                                                                                   
 8     REN     21550      10                                                                                   
                                                                                                               
*           _                                                                                                  
 _ __ _   _| | ___  ___                                                                                        
| '__| | | | |/ _ \/ __|                                                                                       
| |  | |_| | |  __/\__ \                                                                                       
|_|   \__,_|_|\___||___/                                                                                       
                                                                                                               
;                                                                                                              
                                                                                                               
                                   | RULES                                                                     
Up to 40 obs WORK.HAVE total obs=8 | =====                                                                     
                                   |                       Lag2                                                
Obs    CITY    MONTH    COUNT      |         Sum           Dif                                                 
                                   |                                                                           
 1     NEV     21519      50       |                        .                                                  
 2     NEV     21519      40       | 50+40    90                                                               
 3     REN     21519      20       |                        .                                                  
 4     REN     21519      80       | 20+80   100                                                               
 5     NEV     21550      15       |                                                                           
 6     NEV     21550      15       | 15+15    30   30-90   -60                                                 
 7     REN     21550      10       |                                                                           
 8     REN     21550      10       | 10+10    20   20-100  -80                                                 
                                                                                                               
*            _               _                                                                                 
  ___  _   _| |_ _ __  _   _| |_                                                                               
 / _ \| | | | __| '_ \| | | | __|                                                                              
| (_) | |_| | |_| |_) | |_| | |_                                                                               
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                              
                |_|                                                                                            
;                                                                                                              
                                                                                                               
Up to 40 obs WORK.WANT total obs=4                                                                             
                                                                                                               
Obs    CNTSUM    CITY    MONTH    COUNT    DIF                                                                 
                                                                                                               
 1        90     NEV     21519      40       .                                                                 
 2       100     REN     21519      80       .                                                                 
 3        30     NEV     21550      15     -60                                                                 
 4        20     REN     21550      10     -80                                                                 
                                                                                                               
                                                                                                               
*                                                                                                              
 _ __  _ __ ___   ___ ___  ___ ___                                                                             
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                            
| |_) | | | (_) | (_|  __/\__ \__ \                                                                            
| .__/|_|  \___/ \___\___||___/___/                                                                            
|_|                                                                                                            
;                                                                                                              
                                                                                                               
                                                                                                               
data want;                                                                                                     
                                                                                                               
  * create a view with the sums;                                                                               
  if _n_=0 then do ; %let rc=%sysfunc(dosubl('                                                                 
                                                                                                               
     data sumVue/view=sumVue;                                                                                  
        retain cntSum 0;                                                                                       
        set have;                                                                                              
        by city month notsorted;                                                                               
        cntSum+count;                                                                                          
        if last.month then do;                                                                                 
           output;                                                                                             
           cntSum=0;                                                                                           
        end;                                                                                                   
     run;quit;                                                                                                 
                                                                                                               
     '));                                                                                                      
                                                                                                               
  end;                                                                                                         
                                                                                                               
  set sumVue;                                                                                                  
  dif=dif2(cntSum);                                                                                            
                                                                                                               
run;quit;                                                                                                      
                                                                                                               
