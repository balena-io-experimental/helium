FROM balenalib/%%BALENA_MACHINE_NAME%%-debian as builder

ARG LORA_REGION
ARG LORA_UDP
ARG SPI_SPEED
ARG PIN_RESET
ARG MINER_URL
ARG MODEL

RUN echo "Choosen region =>" $LORA_REGION
RUN echo "Choosen LoRa UDP port => " $LORA_UDP
RUN echo "Choosen SPI_SPEED =>" $SPI_SPEED
RUN echo "Choosen PIN reset =>" $PIN_RESET
RUN echo "Choosen URL miner =>" $MINER_URL
RUN echo "Choosen RAK MODEL =>" $MODEL

RUN apt-get update && install_packages git build-essential wget


WORKDIR /build

RUN if [ -z "$MODEL" ] ; then echo MODEL has not been set, resuming... ; fi
RUN if [ "$MODEL" = "RAK2245" ] ; then  git clone https://github.com/Lora-net/lora_gateway.git ; else git clone https://github.com/PastaGringo/sx1302_hal.git ;  fi


RUN if [ "$MODEL" = "RAK2287" ] ; then cd sx1302_hal; fi
RUN if [ "$MODEL" = "RAK2287" ] ; then make clean all; fi
RUN if [ "$MODEL" = "RAK2287" ] ; then make install; fi
RUN if [ "$MODEL" = "RAK2287" ] ; then make install_conf; fi
RUN if [ "$MODEL" = "RAK2287" ] ; then cd ..; fi

RUN if [ "$MODEL" = "RAK2245" ] ; then cc loragw_spi.native.c /build/lora_gateway/libloragw/src/; fi

RUN if [ -z "$SPI_SPEED" ] ; then echo SPI_SPEED has not been set, resuming... ; else sed -i -e "s/2000000/$SPI_SPEED/g" /build/lora_gateway/libloragw/src/loragw_spi.native.c ; fi

RUN if [ "$MODEL" = "RAK2245" ] ; then git clone https://github.com/Lora-net/packet_forwarder.git; fi
RUN if [ "$MODEL" = "RAK2245" ] ; then cc lora_pkt_fwd.c /build/packet_forwarder/lora_pkt_fwd/src; fi


COPY global_conf_US.json .
COPY global_conf_EU.json .

RUN if [ "$LORA_REGION" = "EU868" ] ; then echo EU config detected && mv global_conf_EU.json global_conf.json ; fi
RUN if [ "$LORA_REGION" = "US915" ] ; then echo US config detected && mv global_conf_US.json global_conf.json ; fi
RUN if [ -z "$MINER_URL" ] ; then echo MINER_URL has not been set, resuming... ; else sed -i -e "s/helium-miner/$MINER_URL/g" global_conf.json ; fi
RUN if [ -z "$LORA_UDP" ] ; then echo LORA_UDP has not been set, resuming... ; else sed -i -e "s/1680/$LORA_UDP/g" global_conf.json ; fi
RUN rm -rf /build/packet_forwarder/lora_pkt_fwd/global_conf.json && cp global_conf.json /build/packet_forwarder/lora_pkt_fwd

WORKDIR /build/packet_forwarder

RUN if [ "$MODEL" = "RAK2245" ] ; then ./compile.sh; fi

COPY start.sh .

RUN if [ -z "$PIN_RESET" ] ; then echo PIN_RESET has not been set, resuming... ; else sed -i -e "s/17/$PIN_RESET/g" start.sh ; fi

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]





#WORKDIR /home/pi/
#RUN git clone https://github.com/PastaGringo/sx1302_hal.git
#WORKDIR /home/pi/sx1302_hal
#RUN make clean all
#RUN make install
#RUN make install_conf
#WORKDIR /home/pi/sx1302_hal/bin
#COPY start.sh .
#RUN chmod +x reset_lgw.sh start.sh
#RUN sed -i -e "s/localhost/helium-miner/g" global_conf.json.sx1250.US915
#ENTRYPOINT ["./start.sh"]