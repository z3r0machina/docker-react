###############################################################################
# BUILD PHASE                                                                 #
###############################################################################

FROM node:alpine as builder

WORKDIR /app

COPY package.json .
RUN npm install

# Want to copy all of the source code now since source code won't be changed in
# production.
COPY . .

RUN ["npm", "run", "build"]


###############################################################################
# RUNTIME PHASE                                                               #
###############################################################################

FROM nginx

# By default, this instruction does nothing, and it is a hint that port 80
# should be exposed. Cloud Providers (e.g. AWS beanstalk) may look at the
# EXPOSE command and map the port automatically.
EXPOSE 8080

# Copy over /app/build directory from the builder phase.
COPY --from=builder /app/build /usr/share/nginx/html

# The default command from nginx will automatically start nginx up.
