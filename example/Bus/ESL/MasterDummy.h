//
// Created by tobias on 02.07.17.
//

#ifndef PROJECT_MASTERDUMMY_H
#define PROJECT_MASTERDUMMY_H
#include "systemc.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "Interfaces.h"

struct MasterDummy : public sc_module {
public:

    //Out-port
    blocking_out <bus_req_t> bus_req;
    blocking_in <bus_resp_t> bus_resp;


    //Variables
    bus_resp_t resp;
    bus_req_t req;

    int cnt;
    //Constructor
    SC_HAS_PROCESS(MasterDummy);

    MasterDummy(sc_module_name name) :
            bus_req("bus_req"),
            bus_resp("bus_resp"){
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {

            if(cnt == 10000000){
                std::cout << "Simulated " << cnt << " bus cycles" << std::endl;
                sc_stop();
                cnt = 10000000;
            }else{
                ++cnt;
            }

            req.data = cnt;

            if(req.addr == 0){
                req.addr = 8;
            }else if(req.addr == 8){
                req.addr = 16;
            }else if(req.addr == 16){
                req.addr = 25;
            }else if(req.addr == 25){
                req.addr = 0;
            }else {
                req.addr = 0;
            }

            if(req.trans_type == SINGLE_READ) req.trans_type = SINGLE_WRITE;
            else req.trans_type = SINGLE_READ;


            bus_req->write(req);
            bus_resp->read(resp);

            wait(SC_ZERO_TIME);
        }
    }
};
#endif //PROJECT_MASTERDUMMY_H
