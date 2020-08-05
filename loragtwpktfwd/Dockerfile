FROM raspbian/stretch as builder
ARG LORA_REGION
ARG LORA_UDP
ARG SPI_SPEED
ARG PIN_RESET
ARG MINER_URL
RUN echo "Choosen region =>" $LORA_REGION
RUN echo "Choosen LoRa UDP port => " $LORA_UDP
RUN echo "Choosen SPI_SPEED =>" $SPI_SPEED
RUN echo "Choosen URL miner =>" $PIN_RESET
RUN echo "Choosen URL miner =>" $MINER_URL
RUN apt-get update && apt-get install -y git build-essential wget
WORKDIR /build
RUN git clone https://github.com/Lora-net/lora_gateway.git
COPY loragw_spi.native.c /build/lora_gateway/libloragw/src/
RUN if [ -z "$SPI_SPEED" ] ; then echo SPI_SPEED has not been set, resuming... ; else sed -i -e "s/2000000/$SPI_SPEED/g" /build/lora_gateway/libloragw/src/loragw_spi.native.c ; fi
RUN git clone https://github.com/Lora-net/packet_forwarder.git
COPY lora_pkt_fwd.c /build/packet_forwarder/lora_pkt_fwd/src
COPY global_conf_US.json .
COPY global_conf_EU.json .
RUN if [ "$LORA_REGION" = "EU868" ] ; then echo EU config detected && mv global_conf_EU.json global_conf.json ; fi
RUN if [ "$LORA_REGION" = "US915" ] ; then echo US config detected && mv global_conf_US.json global_conf.json ; fi
RUN if [ -z "$MINER_URL" ] ; then echo MINER_URL has not been set, resuming... ; else sed -i -e "s/helium-miner/$MINER_URL/g" global_conf.json ; fi
RUN if [ -z "$LORA_UDP" ] ; then echo LORA_UDP has not been set, resuming... ; else sed -i -e "s/1680/$LORA_UDP/g" global_conf.json ; fi
RUN rm -rf /build/packet_forwarder/lora_pkt_fwd/global_conf.json && cp global_conf.json /build/packet_forwarder/lora_pkt_fwd
WORKDIR /build/packet_forwarder
RUN ./compile.sh
COPY start.sh .
RUN if [ -z "$PIN_RESET" ] ; then echo PIN_RESET has not been set, resuming... ; else sed -i -e "s/17/$PIN_RESET/g" start.sh ; fi
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]
